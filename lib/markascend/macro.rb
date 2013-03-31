module Markascend
  class Macro
    def initialize env, name, content, inline
      @env = env
      if meth = env[:macros][name]
        @parse = send meth, content, inline
      else
        # keep undefined macros
        @parse = "\\#{name}"
      end
    end

    attr_reader :parse
  end
end
