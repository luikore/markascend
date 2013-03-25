module Markascend
  class Base
    REC_START = /\A[\+\-\>]\ /
    REC_BLOCK_STARTS = {
      '+ ' => /\+\ /,
      '- ' => /\-\ /,
      '> ' => /\>\ /
    }

    def initialize src, start_linenum=0
      @src = StringScanner.new src
      @linenum = start_linenum
      @out = []
    end

    def parse
      if @linenum == 0
        parse_prelude
      end
      while parse_rec_block or parse_hx or parse_line
      end
      raise "failed to parse at: #{@linenum}" unless @src.eos?
      @out.join
    end

    def parse_rec_block
      return unless @src.match? REC_START
      line, block = scan_line_and_block
      return unless line
      rec_block = line[REC_START]
      wrapper_begin, elem_begin, elem_end, wrapper_end =
        case rec_block
        when '+ '; ['<ul>', '<li>', '</li>', '/ul']
        when '- '; ['<ul>', '<li>', '</li>', '/ul']
        when '> '; ['', '<quote>', '</quote>', '']
        end

      @out << wrapper_begin
      @out << elem_begin
      @out << Markascend.new(line[2..-1] + block, @linenum).parse
      @out << elem_end
      while @src.match?(REC_BLOCK_STARTS[rec_block])
        @out << elem_begin
        parse_line
        @out << elem_end
      end
      @out << wrapper_end
      true
    end

    def parse_prelude
    end

    def parse_hx
      hx = @src.scan /h[1-6](\#\w+(-\w+)*)?\ /
      return unless hx
      hx.strip!
      if hx.size > 2
        id_attr = %Q{ id="#{hx[3..-1]}"}
      end
      hx = hx[0...2]

      @out << "<#{hx}#{id_attr}>"
      # todo make it a block
      parse_line
      @out << "</#{hx}>"
      true
    end

    def parse_line
      line, block = scan_line_and_block
      return unless line
      @out << LineUnit.new(line, block, @linenum).parse
      true
    end

    def scan_line_and_block
      if @src.scan(/\ *\t/)
        raise SyntaxError, "line starting with a tab: #@linenum"
      end
      if line = @src.scan(/.+?(?:\n|\z)/)
        block = @src.scan(/
          (?:\ *\n)*        # leading empty lines
          (?<indent>\ {2,})
          .*?(?:\n|\z)      # first line content
          (
            \g<indent>\ *
            .*?(?:\n|\z)    # rest line content
            |
            (?:\ *\n)*      # rest empty line
          )*
        /x)
        block = nil if block =~ /\A\s*\z/
        # undent block
        if block
          /
            (?:\ *\n)*
            (?<indent>\ {2,})
          /x =~ block
          block.gsub! /^#{indent}/, ''
        end
      end
      [line, block]
    end
  end
end
