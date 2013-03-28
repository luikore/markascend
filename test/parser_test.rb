require_relative "test_helper"

class ParserTest < MarkascendTest
  def before
    @env = {}
  end

  def test_hx
    b = Parser.new @env, "h1#centered lovely day!"
    assert_equal "<h1 id=\"centered\">lovely day!</h1>", b.parse
  end

  def test_blocked_hx
    b = Parser.new @env, "h3 followed by \\nop a block\n  content of block"
    assert_equal "<h3>followed by \\nop a block\n</h3>", b.parse
  end

  def test_rec_block
    b = Parser.new @env, "- ul1\n- ul2\n  + ol1\n  + ol2"
    ol = "<ol><li>ol1</li>" + "<li>ol2</li></ol>"
    ul = "<ul><li>ul1</li>" + "<li>ul2<br>#{ol}</li></ul>"
    assert_equal ul, b.parse
  end
end
