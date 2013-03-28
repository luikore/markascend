require_relative "test_helper"

class LineUnitTest < MarkascendTest
  def before
    @env = {}
  end

  def test_validate_line_unit
    assert_equal LineUnit.instance_methods.grep(/parse_/).sort, LineUnit.parsers.sort
  end

  def test_nested_italic_and_bold
    l = LineUnit.new @env, 'outside***i*b**', nil, 0
    assert_equal 'outside<b><i>i</i>b</b>', l.parse
  end

  def test_code
    l = LineUnit.new @env, '`\\\\code`', nil, 0
    assert_equal '<code>\\\\code</code>', l.parse

    l = LineUnit.new @env, '``c`ode``', nil, 0
    assert_equal '<code>c`ode</code>', l.parse

    l = LineUnit.new @env, '`` ```', nil, 0
    assert_equal '<code> </code>`', l.parse
  end

  def test_math
    l = LineUnit.new @env, '$\\\\math\$ $', nil, 0
    assert_equal '<code class="math">\\\\math\$ </code>', l.parse
  end
end
