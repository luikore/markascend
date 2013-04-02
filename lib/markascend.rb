require "strscan"
require "cgi"
require "csv"
require "yaml"
require "base64"
require "open3"
require "pygments"

module Markascend
  VERSION = '0.1'

  DEFAULT_MACROS = Hash.[] %w[
    del underline sub sup
    img html slim
    csv headless_csv
    latex
    options hi
    dot

    twitter weibo
    wiki
    gist
    video
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

  class Env < ::Hash
    def initialize h
      merge! h
    end

    def warn msg
      self[:warnings][self[:src].pos] = msg
    end
  end

  class << Markascend
    def compile src, opts={}
      src = src.gsub "\t", '  '
      Parser.new(build_env(opts), src).parse
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

      scope = opts[:scope] || Object.new.send(:binding)

      Env.new\
        options: {},           # for \options macro
        footnotes: {},         # for [.] and [:] elements
        scope: scope,          # for template engines
        macros: macros,        # enabled macros
        line_units: line_units # enabled inline parsers with order
    end

    attr_accessor :inline_parsers, :macros

    define_method :escape_html, &CGI.method(:escape_html)

    def escape_attr s
      # http://www.w3.org/TR/html5/syntax.html#attributes-0
      s ? (s.gsub /\"/, '\\"') : ''
    end

    def hilite s, lang
      # TODO ma lexer
      if !lang or lang =~ /\A(ma(rkascend)?)?\z/i
        s.gsub(/(<)|(>)|&/){$1 ? '&lt;' : $2 ? '&gt;' : '&amp;'}
      else
        ::Pygments.highlight s, lexer: lang
      end
    end
  end
end

require_relative "markascend/parser"
require_relative "markascend/line_unit"
require_relative "markascend/macro"
require_relative "markascend/builtin_macros"
require_relative "markascend/popular_company_macros"
