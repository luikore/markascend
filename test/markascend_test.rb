require_relative "test_helper"

class MarkascendTest < BaseTest
  def test_strip_tags
    assert_equal '', Markascend.strip_tags('<script fraud-prop="></script>"></script>')
    assert_equal 'Bold', Markascend.strip_tags('<b>Bold</b>')
  end
end
