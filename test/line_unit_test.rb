require_relative "test_helper"

class LineUnitTest < MarkascendTest
  def test_line
    l = LineUnit.new 'a*b*c', nil, 0
    assert_equal 'a*b*c', l.parse
  end
end
