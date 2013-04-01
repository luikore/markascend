require "test/unit"
require_relative "../lib/markascend"
begin
  require "pry"
rescue LoadError
end

require "slim"

class MarkascendTest < Test::Unit::TestCase
  include Markascend
end
