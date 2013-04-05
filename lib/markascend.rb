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

  class << Markascend
    def compile src, opts={}
      src = src.gsub "\t", '  '
      Parser.new(Env.new(opts), src).parse
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

require_relative "markascend/env"
require_relative "markascend/parser"
require_relative "markascend/line_unit"
require_relative "markascend/macro"
require_relative "markascend/builtin_macros"
require_relative "markascend/popular_company_macros"
