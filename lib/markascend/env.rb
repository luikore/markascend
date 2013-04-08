module Markascend
  class Env
    attr_reader :autolink, :inline_img, :sandbox, :toc
    attr_reader :macros, :line_units, :scope, :options, :footnotes, :srcs, :warnings
    attr_accessor :hi

    def initialize(autolink: %w[http https ftp mailto], inline_img: false, sandbox: false, toc: false, **opts)
      @autolink = autolink
      @inline_img = inline_img
      @sandbox = sandbox
      @toc = toc

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
      elsif @sandbox
        @macros = SANDBOX_MACROS
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
      @srcs = []      # recursive parser stack, everyone has the contiguous right one scanned
      @warnings = {}
      @hi = nil       # current syntax hiliter
    end

    def warn msg
      if @srcs.size
        current_src = @srcs.last
        line = @srcs.first.string.count("\n") - current_src.string[(current_src.pos)..-1].count("\n")
        @warnings[line] = msg
      else
        # warnings without source is set to line 0
        @warnings[0] = msg
      end
    end
  end
end
