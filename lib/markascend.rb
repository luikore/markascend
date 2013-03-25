require "strscan"
require_relative "markascend/base"
require_relative "markascend/line_unit"
require_relative "markascend/macros"

module Markascend
  VERSION = '0.1'

  def Markascend.compile src, opts
    Baes.new(src).parse
  end
end
