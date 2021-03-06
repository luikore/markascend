require "strscan"
require "cgi"
require "csv"
require "yaml"
require "base64"
require "open3"
require "open-uri"

require "pygments"
require "filemagic"
require "slim"
require "dimensions"
require "sanitize"

module Markascend
  VERSION = '0.2'

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

  SANDBOX_MACROS = DEFAULT_MACROS.dup.delete_if do |k, v|
    %w[slim options dot].include? k
  end

  # NOTE on the order:
  # - link/bold/italic can contain char
  #   but link need not interpolate with bold or italic, seems too rare cased
  # - bold/italic can interpolate with each other
  # - escapes are processed in the char parser, link/bold/italic can use escape chars
  DEFAULT_LINE_UNITS = %w[
    inline_code
    math
    autolink
    macro
    link
    bold_italic
    char
  ].map{|k| "parse_#{k}"}

  class << Markascend
    def compile src, opts={}
      src = src.gsub "\t", '  '
      env = Env.new opts
      res = Parser.new(env, src).parse

      if env.toc and !env.toc.empty?
        res = (generate_toc(env.toc) << res)
      end

      if env.footnotes and !env.footnotes.empty?
        res << generate_footnotes(env.footnotes)
      end

      res
    end

    attr_accessor :inline_parsers, :macros

    # escape html
    def escape_html s
      CGI.escape_html s
    end

    # escape string so that the result can be placed inside double-quoted value of a tag property
    def escape_attr s
      # http://www.w3.org/TR/html5/syntax.html#attributes-0
      s ? (s.gsub /"/, '&quot;') : ''
    end

    # todo escape href to be free of javascript when needed

    # escape string so that the result can be placed inside a `<pre>` tag
    def escape_pre s
      s.gsub(/(<)|(>)|&/){$1 ? '&lt;' : $2 ? '&gt;' : '&amp;'}
    end

    # syntax hilite s with lang
    def hilite s, lang, inline=false
      if !lang or lang =~ /\A(ma(rkascend)?)?\z/i or !(::Pygments::Lexer.find lang)
        # TODO ma lexer
        s = inline ? (escape_html s) : (escape_pre s)
      else
        s = Pygments.highlight s, lexer: lang, options: {nowrap: true}
      end

      # TODO config class
      if inline
        %Q|<code class="highlight">#{s}</code>|
      else
        %Q|<pre><code class="highlight">#{s}</code></pre>|
      end
    end

    # detect mime type of the buffer
    def mime buffer
      fm = FileMagic.new FileMagic::MAGIC_MIME_TYPE
      res = fm.buffer buffer
      fm.close
      res
    end

    # detect image size
    def img_size buffer
      io = StringIO.new(buffer)
      io.extend ::Dimensions::IO
      io.read
      io.dimensions
    end

    # simple strip tags from s
    # NOTE should not be used for user-generated content
    def strip_tags s
      # deal with html tags only
      s.gsub(/
        \<\s*(script|style)\b
          (?:
            (["']).*?\2|[^\>] # properties
          )*
        \>
        .*?
        \<\s*\/\s*\1\s*\>
      /x, '').gsub(/
        \<\s*(?:\/\s*)?
          [\w\:]+\b           # tag name
          (?:
            (["']).*?\1|[^\>] # properties
          )*
        \>
      /x, '')
    end

    # keep only valid html tags
    def sanitize s
      ::Sanitize.clean s, ::Sanitize::Config::BASIC
    end

    private

    def generate_toc toc
      res = '<div id="toc"><ol>'
      levels = toc.values.map(&:first).uniq.sort
      prev_level = 0
      toc.each do |id, (x, header_content)| # x as in "hx"
        level = levels.index(x)
        if level >= prev_level
          (level - prev_level).times do
            res << "<ol>"
          end
        elsif
          (prev_level - level).times do
            res << "</ol>"
          end
        end
        prev_level = level
        title = strip_tags header_content
        res << %Q{<li><a href="\##{id}">#{title}</a></li>}
      end
      prev_level.times do
        res << "</ol>"
      end
      res << "</ol></div>"
    end

    def generate_footnotes footnotes
      res = '<div id="footnotes"><ol>'
      i = 0
      footnotes.each do |abbrev, detail|
        i += 1
        res << %Q|<li id="footnote-#{i}">#{escape_html detail}</li>|
      end
      res << "</ol></div>"
    end
  end
end

require_relative "markascend/env"
require_relative "markascend/parser"
require_relative "markascend/line_unit"
require_relative "markascend/macro"
require_relative "markascend/builtin_macros"
require_relative "markascend/popular_company_macros"
