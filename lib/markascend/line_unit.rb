module Markascend
  LineUnit = Struct.new :line, :block, :linenum
  # process a line with (maybe) a followed up indented block
  class LineUnit
    def parse
      line
    end
  end
end
