require_relative "spec_helper"

describe Markascend do
  it 'strips script tags' do
    assert_equal '', Markascend.strip_tags('<script fraud-prop="></script>"></script>')
    assert_equal 'Bold', Markascend.strip_tags('<b>Bold</b>')
  end

  it 'generates toc' do
    res = Markascend.compile <<-MA, toc: true
h1 h1
h5 h5
h3 h3
    MA
    dom = Nokogiri::HTML(res).xpath('//div[@id="toc"]/ol').first
    assert_equal ['li', 'ol'], dom.children.map(&:name)
    assert_equal ['ol', 'li'], dom.children[1].children.map(&:name)
  end

  it 'generates footnotes' do
    src = '[.](first note shown as number) [.*](second note shown as star)'
    res = Markascend.compile(src)
    dom = Nokogiri::HTML(res)
    hrefs = dom.css('a[href]').map{|e| e['href']}
    ids = dom.css('li[id]').map{|e| e['id']}
    assert_equal hrefs, ids.map{|id| "##{id}"}
  end
end
