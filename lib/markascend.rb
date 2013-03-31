require "strscan"
require "cgi"

module Markascend
  VERSION = '0.1'

  DEFAULT_MACROS = Hash.[] %w[
    del underline sub sup
    img html slim
    csv
    latex
    options hi
    d3 dot
  ].map{|k| [k, "parse_#{k}"]}

  # NOTE on the order:
  # - link/bold/italic can contain char
  #   but link need not interpolate with bold or italic, seems too rare cased
  # - bold/italic can interpolate with each other
  # - escapes are processed in the char parser, link/bold/italic can use escape chars
  DEFAULT_LINE_UNITS = %w[
    inline_code
    math
    auto_link
    macro
    link
    bold_italic
    char
  ].map{|k| "parse_#{k}"}

  class << Markascend
    def compile src, opts
      Baes.new(build_env(opts), src).parse
    end

    def build_env opts
      if opts[:macros]
        macros = {}
        opts[:macros].each do |m|
          meth = "parse_#{m}"
          if Macro.respond_to?(meth)
            macros[m] = meth
          else
            raise ArgumentError, "macro processor #{meth} not defined"
          end
        end
      else
        macros = DEFAULT_MACROS
      end

      if opts[:line_units]
        line_units = opts[:line_units].map do |m|
          meth = "parse_#{m}"
          if LineUnit.respond_to?(meth)
            meth
          else
            raise ArgumentError, "line-unit parser #{meth} not defined"
          end
        end
      else
        line_units = DEFAULT_LINE_UNITS
      end

      {options: {}, footnotes: {}, macros: macros, line_units: line_units}
    end

    attr_accessor :inline_parsers, :macros

    define_method :escape_html, &CGI.method(:escape_html)

    def escape_attr s
      s.gsub /[\\\"]/, '\\\1'
    end
  end
end

require_relative "markascend/parser"
require_relative "markascend/line_unit"
require_relative "markascend/macro"
require_relative "markascend/builtin_macros"
require_relative "markascend/popular_company_macros"
