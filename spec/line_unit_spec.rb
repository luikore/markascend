require_relative "spec_helper"

describe LineUnit do
  it "parses nested italic and bold" do
    assert_equal 'outside<b><i>i</i>b</b>', parse('outside***i*b**').join
  end

  it "parses code" do
    assert_equal '<code class="highlight">\\\\code</code>', parse('`\\\\code`').join
    assert_equal '<code class="highlight">c`ode</code>', parse('``c`ode``').join
    assert_equal '<code class="highlight"> </code>`', parse('`` ```').join
  end

  it "parses math" do
    assert_equal '<code class="math">\\\\math\$ </code>', parse('$\\\\math\$ $').join
  end

  it "parses link" do
    assert_equal '<a href="href" rel="nofollow">a</a>', parse('[a](href)').join
  end

  it "parses footnote" do
    assert_equal '<a href="#footnote-1">1</a>', parse('[.](first note)').join
    assert_equal '<a href="#footnote-2">two</a>', parse('[.two](second note)').join
    assert_equal [:footnote_id_ref, 1], parse('[:1]').first
    assert_equal [:footnote_id_ref, 22], parse('[:22]').first
    assert_equal [:footnote_acronym_ref, "two"], parse('[:two]').first
  end

  it "won't parse footnot in sandbox mode" do
    make_sandbox_env
    first_note = '[.](first note)'
    assert_equal first_note, parse('[.](first note)').join
  end

  def parse src
    l = LineUnit.new @env, src, nil
    l.parse []
  end
end
