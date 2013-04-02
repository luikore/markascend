require "test/unit"
require_relative "../lib/markascend"
begin
  require "pry"
rescue LoadError
end

require "slim"
require "nokogiri" # for parsing the result
require "tempfile"

class MarkascendTest < Test::Unit::TestCase
  include Markascend
  def setup
    @env = Env.build({})
  end
end
