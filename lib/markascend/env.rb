module Markascend
  class Env < ::Hash
    def self.build opts
      e = new

      if opts[:macros]
        macros = {}
        opts[:macros].each do |m|
          meth = "parse_#{m}"
          if Macro.respond_to?(meth)
            macros[m] = meth
          else
            raise ArgumentError, "macro processor #{meth} not defined"
          end
        end
      else
        macros = DEFAULT_MACROS
      end
      e[:macros] = macros # enabled ones

      if opts[:line_units]
        line_units = opts[:line_units].map do |m|
          meth = "parse_#{m}"
          if LineUnit.respond_to?(meth)
            meth
          else
            raise ArgumentError, "line-unit parser #{meth} not defined"
          end
        end
      else
        line_units = DEFAULT_LINE_UNITS
      end
      e[:line_units] = line_units

      e[:scope] = opts[:scope] || Object.new.send(:binding)
      e[:options] = {}   # for \options macro
      e[:footnotes] = {} # for [.] and [:] elements
      e[:srcs] = []
      e
    end

    def warn msg
      pos = self[:srcs].map(&:pos).inject(0, &:+)
      self[:warnings][pos] = msg
    end
  end
end
