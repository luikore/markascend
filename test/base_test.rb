require_relative "test_helper"

class BaseTest < MarkascendTest
  def test_hx
    b = Base.new "h1#centered lovely day!", 0
    assert_equal "<h1 id=\"centered\">lovely day!</h1>", b.parse
  end

  def test_blocked_hx
    b = Base.new "h3 followed by \\nonsense a block\n  content of block", 0
    assert_equal "<h3>followed by \\nonsense a block\n</h3>", b.parse
  end

  def test_rec_block
    b = Base.new "- ul1\n- ul2"
    assert_equal "<ul><li>ul1\n</li><li>- ul2</li>/ul", b.parse
  end
end
