require_relative "spec_helper"

describe 'popular company macros' do
  it 'parses \twitter' do
    assert_equal %Q{<a href="https://twitter.com/dhh">@dhh</a>}, parse("\\twitter(@dhh)")
  end

  it 'parses \weibo' do
    assert_equal %Q{<a href="https://weibo.com/dhh">@dhh</a>}, parse("\\weibo(@dhh)")
  end

  it 'parses \wiki' do
    assert_equal %Q|<a href="http://en.wikipedia.org/wiki/ruby(programing_language)">ruby(programing_language)</a>|, parse("\\wiki{ruby(programing_language)}")
  end

  it 'parses \gitst' do
    res = %Q{<script src="https://gist.github.com/luikore/737238.js"></script>}
    assert_equal res, parse("\\gist(luikore/737238)")
    assert_equal res, parse("\\gist(luikore/737238.git)")
    assert_equal res, parse("\\gist(gist.github.com/luikore/737238.git)")
    assert_equal res, parse("\\gist(https://gist.github.com/luikore/737238)")
  end

  it 'parses \video' do
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
    l = LineUnit.new @env, src, nil
    l.parse
  end
end
