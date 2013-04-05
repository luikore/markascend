module Markascend
  class Parser
    REC_START = /\A[\+\-\>]\ /
    NON_PARA_START = /
      ^[\+\-\>]\                   # rec block
      |
      ^\|\ *(?!\d)\w*\ *$          # block code
      |
      ^h[1-6](?:\#\w+(?:-\w+)*)?\  # header
    /x
    REC_BLOCK_STARTS = {
      '+ ' => /\+\ /,
      '- ' => /\-\ /,
      '> ' => /\>\ /
    }

    def initialize env, src
      @src = StringScanner.new src
      @env = env
      @top_level = @env.srcs.empty?
      @env.srcs.push @src
    end

    def parse
      @out = []
      while parse_new_line or parse_rec_block or parse_hx or parse_block_code or parse_paragraph
      end
      unless @src.eos?
        @env.warn 'reached end of input'
      end
      @env.srcs.pop

      @out.map! do |(node, content)|
        case node
        when :footnode_id_ref
          if content < 1 or content > @env.footnotes.size
            raise "footnote not defined: #{content}"
          end
          %Q|<a href="#footnote-#{content}">#{content}</a>|
        when :footnode_acronym_ref
          unless index = @env.footnotes.find_index{|k, _| k == content }
            raise "footnote note defined: #{content}"
          end
          %Q|<a href="#footnote-#{index + 1}">#{content}</a>|
        else
          node
        end
      end
      @out.join
    end

    def warnings
      @env.warnings
    end

    def parse_new_line
      if @src.scan(/\ *\n/)
        @out << '<br>'
        true
      end
    end

    def parse_rec_block
      return unless @src.match? REC_START

      # first elem, scans the whole of following string:
      # |
      #   + line 1 of the li. an embed \macro
      #       macro content
      #     line 2 of the li.
      #     line 3 of the li.
      #
      # NOTE that first line is always not indented
      line, block = scan_line_and_block 2
      return unless line
      rec_start = line[REC_START]
      wrapper_begin, elem_begin, elem_end, wrapper_end =
        case rec_start
        when '+ '; ['<ol>', '<li>', '</li>', '</ol>']
        when '- '; ['<ul>', '<li>', '</li>', '</ul>']
        when '> '; ['', '<quote>', '</quote>', '']
        end
      elems = ["#{line[2..-1]}#{block}"]

      # followed up elems
      block_start_re = REC_BLOCK_STARTS[rec_start]
      while @src.match?(block_start_re)
        line, block = scan_line_and_block 2
        break unless line
        elems << "#{line[2..-1]}#{block}"
      end

      # generate
      @out << wrapper_begin
      elems.each do |elem|
        @out << elem_begin
        elem.rstrip!
        @out << Parser.new(@env, elem).parse
        @out << elem_end
      end
      @out << wrapper_end
      true
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
      line, block = scan_line_and_block
      if line
        LineUnit.new(@env, line, block).parse(@out)
      end
      # consume one more empty line if possible
      @src.scan /\ *\n/ if (!block or block.empty?)
      @out.pop if @out.last == :"<br>"
      @out << "</#{hx}>"
      true
    end

    def parse_block_code
      if lang = @src.scan(/\|\ *(?!\d)\w*\ *\n/)
        lang = lang[1..-1].strip
        if lang.empty? and @env.hi
          lang = @env.hi
        end
        block = @src.scan(/
          (
            \ *\n      # empty line
          |
            \ {2,}.*\n # line indented equal to 2 or more than 2
          )*
        /x)
        block.gsub!(/^  /, '')
        block.rstrip!
        @out << (::Markascend.hilite block, lang)
        true
      end
    end

    def parse_paragraph
      @src.match?(/\ */)
      indent = @src.matched_size
      line, block = scan_line_and_block
      if line
        @out << :"<p>" if @top_level
        LineUnit.new(@env, line, block).parse(@out)

        # same indent and not matching rec/code blocks
        while (@src.match?(/\ */); @src.matched_size) == indent and !@src.match?(NON_PARA_START)
          line, block = scan_line_and_block
          break unless line
          LineUnit.new(@env, line, block).parse(@out)
        end
        # consume one more empty line if possible
        @src.scan /\ *\n/
        # delete back last <br>
        @out.pop if @out.last == :"<br>"
        @out << :"</p>" if @top_level
        true
      end
    end

    def scan_line_and_block undent=:all
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
          if undent == :all
            /
              (?:\ *\n)*
              (?<indent>\ {2,})
            /x =~ block
            block.gsub! /^#{indent}/, ''
          else
            block.gsub! /^\ \ /, ''
          end
        end
      end
      [line, block]
    end
  end
end
