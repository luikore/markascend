module Markascend
  class Env
    attr_reader :macros, :line_units, :scope, :options, :footnotes, :srcs, :warnings
    attr_accessor :hi

    def initialize opts
      if opts[:macros]
        @macros = {}
        opts[:macros].each do |m|
          meth = "parse_#{m}"
          if Macro.respond_to?(meth)
            @macros[m] = meth
          else
            raise ArgumentError, "macro processor #{meth} not defined"
          end
        end
      else
        @macros = DEFAULT_MACROS
      end

      if opts[:line_units]
        @line_units = opts[:line_units].map do |m|
          meth = "parse_#{m}"
          if LineUnit.respond_to?(meth)
            meth
          else
            raise ArgumentError, "line-unit parser #{meth} not defined"
          end
        end
      else
        @line_units = DEFAULT_LINE_UNITS
      end

      @scope = opts[:scope] || Object.new.send(:binding)
      @options = {}   # for \options macro
      @footnotes = {} # for [.] and [:] elements
      @srcs = []
      @warnings = {}
      @options = {}
      @hi = nil
    end

    def warn msg
      pos = @srcs.map(&:pos).inject(0, &:+)
      @warnings[pos] = msg
    end
  end
end
