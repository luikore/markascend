module Markascend
  class Macro
    Markascend.macros = [
    ]

    def initialize name, content, inline
      if Markascend.macros.include?(name)
        @parse = send "parse_#{name}", content, inline
      else
        # keep undefined macros
        @parse = "\\#{name}"
      end
    end

    attr_reader :parse
  end
end
