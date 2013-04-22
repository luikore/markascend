require "rspec/core"
require "rspec/mocks"
require "rspec/autorun"
require_relative "../lib/markascend"
begin
  require "pry"
rescue LoadError
end
require "tempfile"

include Markascend

RSpec.configure do |config|
  config.expect_with :stdlib
  config.before :each do
    @env = Env.new({})
  end
end

def make_sandbox_env
  @env = Env.new sandbox: true
end
