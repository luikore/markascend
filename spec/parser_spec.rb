require_relative "spec_helper"

describe Parser do
  it "parses hx" do
    b = Parser.new @env, "h1#cen-tered lovely day!"
    assert_equal "<h1 id=\"cen-tered\">lovely day!</h1>", b.parse
  end

  it "parses sandbox hx" do
    make_sandbox_env
    b = Parser.new @env, "h1#cen-tered lovely day!"
    assert_equal "<h1>lovely day!</h1>", b.parse
  end

  it "parses blocked hx" do
    b = Parser.new @env, "h3 followed by \\nop a block\n  content of block"
    assert_equal "<h3>followed by \\nop a block</h3>", b.parse
  end

  it "parses rec block" do
    b = Parser.new @env, <<-MA
- ul1
- ul2
  + ol1
  + ol2
- > quote1
    quote2
MA
    ol = "<ol><li>ol1</li>" + "<li>ol2</li></ol>"
    quote = "<quote>quote1<br>quote2</quote>"
    ul = "<ul><li>ul1</li>" + "<li>ul2#{ol}</li>" + "<li>#{quote}</li></ul>"
    assert_equal ul, b.parse.strip
  end

  it "generates waring for missing macro contents" do
    b = Parser.new @env, <<-MA
- ul1
  + ol1
    - ul2
      + ol2 \\img()
MA
    b.parse
    assert b.warnings[4]
  end

  it "parses code block" do
    code_text = proc do |b|
      t = Nokogiri::HTML(b.parse.strip).xpath('//pre/code').text
      CGI.unescape_html(t).strip
    end

    b = Parser.new @env, <<-MA
|ruby
  puts 'hello world'
MA
    assert_equal "puts 'hello world'", code_text[b]

    b = Parser.new @env, <<-MA
|
  puts 'hello world'
MA
    assert_equal "puts 'hello world'", code_text[b]
  end

  it "retains content of undefined inline macro, but not for undefined block macro" do
    invalid = "\\invalid{ <content> }"
    expected = "<p>#{CGI.escape_html invalid}</p>"
    assert_equal expected, Parser.new(@env, invalid).parse

    invalid = "\\invalid\n  <content>"
    assert_equal "<p>\\invalid</p>", Parser.new(@env, invalid).parse
  end

  it 'disables \options in sandbox mode' do
    make_sandbox_env
    src = '\options(a.png)'
    expected = "<p>#{CGI.escape_html src}</p>"
    assert_equal expected, Parser.new(@env, src).parse
  end

  it 'should have valid default macro list' do
    assert_equal Macro.instance_methods.grep(/parse_/).map(&:to_s).sort, Markascend::DEFAULT_MACROS.values.sort
  end

  it 'should have valid default line unit parser list' do
    assert_equal LineUnit.instance_methods.grep(/parse_/).map(&:to_s).sort, Markascend::DEFAULT_LINE_UNITS.sort
  end
end
