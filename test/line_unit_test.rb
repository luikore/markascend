require_relative "test_helper"

class LineUnitTest < MarkascendTest
  def test_validate_line_unit
    assert_equal LineUnit.instance_methods.grep(/parse_/).sort, LineUnit.parsers.sort
  end

  def test_nested_italic_and_bold
    l = LineUnit.new 'outside***i*b**', nil, 0
    assert_equal 'outside<b><i>i</i>b</b>', l.parse
  end
end
