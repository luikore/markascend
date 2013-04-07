module Markascend
  # inline contains the src for fallback
  Macro = ::Struct.new :env, :content, :inline
  class Macro
    def parse name
      self.content ||= ''
      if meth = env.macros[name]
        res = send meth
      end
      res or (inline ? ::Markascend.escape_html(inline) : "\\#{name}")
    end
  end
end
