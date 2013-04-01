require_relative "test_helper"

class ParserTest < MarkascendTest
  def setup
    @env = Markascend.build_env({})
  end

  def test_hx
    b = Parser.new @env, "h1#cen-tered lovely day!"
    assert_equal "<h1 id=\"cen-tered\">lovely day!</h1>", b.parse
  end

  def test_blocked_hx
    b = Parser.new @env, "h3 followed by \\nop a block\n  content of block"
    assert_equal "<h3>followed by \\nop a block<br></h3>", b.parse
  end

  def test_rec_block
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
    ul = "<ul><li>ul1</li>" + "<li>ul2<br>#{ol}</li>" + "<li>#{quote}</li></ul>"
    assert_equal ul, b.parse.strip
  end

  # XXX implemented as line unit, but tested as parser
  def test_code_block
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

  def test_footnote_validation

  end
end
