require_relative "test_helper"

class PopularCompanyMacrosTest < MarkascendTest
  def setup
    @env = Markascend.build_env({})
  end

  def test_twitter
    assert_equal %Q{<a href="https://twitter.com/dhh">@dhh</a>}, parse("\\twitter(@dhh)")
  end

  def test_weibo
    assert_equal %Q{<a href="https://weibo.com/dhh">@dhh</a>}, parse("\\weibo(@dhh)")
  end

  def test_wiki
    assert_equal %Q|<a href="http://en.wikipedia.org/wiki/ruby(programing_language)">ruby(programing_language)</a>|, parse("\\wiki{ruby(programing_language)}")
  end

  def test_gist
    res = %Q{<script src="https://gist.github.com/luikore/737238.js"></script>}
    assert_equal res, parse("\\gist(luikore/737238)")
    assert_equal res, parse("\\gist(luikore/737238.git)")
    assert_equal res, parse("\\gist(gist.github.com/luikore/737238.git)")
    assert_equal res, parse("\\gist(https://gist.github.com/luikore/737238)")
  end

  def test_video
    youtube = parse("\\video(400x200 youtu.be/watch?v=TGPvtlnwH6E)")
    assert youtube.start_with? '<iframe width="400" height="200"'
    assert youtube.index('/embed/TGPvtlnwH6E'), youtube.inspect

    vimeo = parse("\\video(400x200 vimeo.com/36820781)")
    assert vimeo.start_with?('<iframe width="400" height="200"'), vimeo.inspect
    assert vimeo.index('/video/36820781'), vimeo.inspect

    nico = parse("\\video(400x200 sm32768)")
    assert nico.start_with?('<script '), nico.inspect
    assert nico.index('/thumb_watch/sm32768'), nico.inspect
  end

  def parse src
    l = LineUnit.new @env, src, nil, 0
    l.parse.join
  end
end
