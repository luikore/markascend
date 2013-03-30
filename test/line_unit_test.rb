require_relative "test_helper"

class LineUnitTest < MarkascendTest
  def before
    @env = {}
  end

  def test_validate_line_unit
    assert_equal LineUnit.instance_methods.grep(/parse_/).sort, LineUnit.parsers.sort
  end

  def test_nested_italic_and_bold
    assert_equal 'outside<b><i>i</i>b</b>', parse('outside***i*b**')
  end

  def test_code
    assert_equal '<code>\\\\code</code>', parse('`\\\\code`')
    assert_equal '<code>c`ode</code>', parse('``c`ode``')
    assert_equal '<code> </code>`', parse('`` ```')
  end

  def test_math
    assert_equal '<code class="math">\\\\math\$ </code>', parse('$\\\\math\$ $')
  end

  def test_inline_macro
  end

  def test_link
    assert_equal '<a href="href">a</a>', parse('[a](href)')
  end

  def parse src
    l = LineUnit.new @env, src, nil, 0
    l.parse
  end
end
