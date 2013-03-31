module Markascend
  Macro = Struct.new :env, :content, :inline
  class Macro
    def parse name
      if meth = env[:macros][name]
        send meth
      else
        "\\#{name}"
      end
    end
  end
end
