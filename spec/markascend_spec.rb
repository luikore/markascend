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
end
