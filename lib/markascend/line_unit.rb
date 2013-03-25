module Markascend
  LineUnit = Struct.new :line, :block, :linenum
  # process a line with (maybe) a followed up indented block
  # there are many things inside a line unit
  class LineUnit
    def parse
      "#{line}#{block}"
    end
  end
end
