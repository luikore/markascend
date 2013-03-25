require "test/unit"
require_relative "../lib/markascend"
begin
  require "pry"
rescue LoadError
end

class MarkascendTest < Test::Unit::TestCase
  include Markascend
end
