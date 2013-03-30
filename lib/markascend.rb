require "strscan"
require "cgi"
require_relative "markascend/parser"
require_relative "markascend/line_unit"
require_relative "markascend/macro"

module Markascend
  VERSION = '0.1'

  def Markascend.compile src, opts
    Baes.new({footnotes: {}}, src).parse
  end
end
