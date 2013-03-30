require_relative "test_helper"

class LineUnitTest < MarkascendTest
  def before
    @env = {}
  end

  def test_validate_line_unit
    assert_equal LineUnit.instance_methods.grep(/parse_/).sort, Markascend.inline_parsers.sort
  end

  def test_nested_italic_and_bold
    assert_equal 'outside<b><i>i</i>b</b>', parse('outside***i*b**').join
  end

  def test_code
    assert_equal '<code>\\\\code</code>', parse('`\\\\code`').join
    assert_equal '<code>c`ode</code>', parse('``c`ode``').join
    assert_equal '<code> </code>`', parse('`` ```').join
  end

  def test_math
    assert_equal '<code class="math">\\\\math\$ </code>', parse('$\\\\math\$ $').join
  end

  def test_inline_macro
  end

  def test_link
    assert_equal '<a href="href">a</a>', parse('[a](href)').join
  end

  def test_footnote
    @env = {footnotes: {}}
    assert_equal '<a href="#footnote-1">1</a>', parse('[.](first note)').join
    assert_equal '<a href="#footnote-2">two</a>', parse('[.two](second note)').join
    assert_equal [:footnote_id_ref, 1], parse('[:1]').first
    assert_equal [:footnote_id_ref, 22], parse('[:22]').first
    assert_equal [:footnote_acronym_ref, "two"], parse('[:two]').first
  end

  def parse src
    l = LineUnit.new @env, src, nil, 0
    l.parse
  end
end
