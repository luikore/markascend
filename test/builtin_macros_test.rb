require_relative "test_helper"

class BuiltinMacrosTest < MarkascendTest
  def setup
    @env = Markascend.build_env({})
  end

  def test_del_underline_sub_sup
    %w[del underline sub sup].each do |x|
      assert_equal "<#{x}>#{x}</#{x}>", parse("\\#{x}(#{x})")
    end
  end

  def parse src
    l = LineUnit.new @env, src, nil, 0
    l.parse.join
  end
end
