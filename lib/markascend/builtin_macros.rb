module Markascend
  class Macro
    %w[del underline sub sup].each do |m|
      eval <<-RUBY
        def parse_#{m}
          "<#{m}>\#{::Markascend.escape_html content}</#{m}>"
        end
      RUBY
    end

    def parse_img

    end

    def parse_html

    end

    def parse_slim

    end
  end
end
