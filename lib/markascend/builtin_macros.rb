module Markascend
  class Macro
    %w[del underline sub sup].each do |m|
      eval <<-RUBY
        def parse_#{m} content, inline
          "<#{m}>\#{::Markascend.escape_html content}</#{m}>"
        end
      RUBY
    end
  end
end
