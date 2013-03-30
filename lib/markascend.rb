require "strscan"
require "cgi"

module Markascend
  VERSION = '0.1'

  class << Markascend
    def compile src, opts
      Baes.new({footnotes: {}}, src).parse
    end

    attr_accessor :inline_parsers, :macros
  end
end

require_relative "markascend/parser"
require_relative "markascend/line_unit"
require_relative "markascend/macro"
require_relative "markascend/builtin_macros"
require_relative "markascend/famous_company_macros"
