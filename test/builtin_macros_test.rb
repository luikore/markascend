require_relative "test_helper"

class BuiltinMacrosTest < BaseTest
  def test_del_underline_sub_sup
    %w[del underline sub sup].each do |x|
      assert_equal "<#{x}>#{x}</#{x}>", parse("\\#{x}(#{x})")
    end
  end

  def test_img
    assert_equal %Q{<img src="src" alt="alt"/>}, parse("\\img(src alt='alt')")
    assert_equal %Q{<a href="href" rel="nofollow"><img src="src" alt="alt"/></a>}, parse("\\img(src alt='alt' href='href')")
  end

  def test_img_escape
    res = parse %q|\img{"><script alt='">/*' href='http://"*/alert(1)</script>'}|
    dom = Nokogiri::HTML res
    assert_equal 'http://"*/alert(1)</script>', dom.css('a').first['href']
    assert_equal '">/*', dom.css('img').first['alt']
    assert_equal '"><script', dom.css('img').first['src']
  end

  def test_html
    html = %Q{<a href="href">a</a>&nbsp;}
    assert_equal html, parse("\\html{#{html}}")
  end

  def test_slim
    html = %Q{<a href="href">a</a>}
    assert_equal html, parse("\\slim(a href='href' a)")
  end

  def test_csv
    res = Markascend.compile <<-MA
\\csv
  name,type
  "Ahri",Mage
  "Miss Fortune",DPS
\\headless_csv
  "Fizz",DPS
  Sejuani,Tank
MA
    table1 = "<thead><tr><th>name</th><th>type</th></tr></thead>" +
             "<tbody><tr><td>Ahri</td><td>Mage</td></tr><tr><td>Miss Fortune</td><td>DPS</td></tr></tbody>"
    table2 = "<tbody><tr><td>Fizz</td><td>DPS</td></tr><tr><td>Sejuani</td><td>Tank</td></tr></tbody>"
    assert res.index table1
    assert res.index table2
  end

  def test_latex
    assert_equal %Q{<code class="latex">\\frac{y}{x}</code>}, parse("\\latex{\\frac{y}{x}}")
  end

  def test_dot
    res = parse("\\dot(digraph G{main -> parse;})").strip
    src = Nokogiri::HTML(res).xpath('//@src').text[/(?<=,).+$/]
    f = Tempfile.new('img')
    f << Base64.decode64(src)
    path = f.path
    f.close
    output = `file #{path}`
    assert output.index('PNG image data'), %Q|generated data should be png: but got #{output.inspect}|
  end

  def test_dot_under_retina
    dimensions = -> {
      res = parse('\dot(digraph G{main -> parse;})').strip
      img = Nokogiri::HTML(res).css('img').first
      [img['width'].to_f, img['height'].to_f]
    }

    width, height = dimensions[]
    @env.instance_variable_set :@retina, true
    rwidth, rheight = dimensions[]

    assert_equal width / 2.0, rwidth
    assert_equal height / 2.0, rheight
  end

  def test_options
    parse("\\options(a: [1, 2])")
    assert_equal({"a" => [1, 2]}, @env.options)
  end

  def test_hi
    parse("\\hi(none)")
    assert_equal nil, @env.hi
    parse("\\hi(c)\\hi(ruby)")
    assert_equal 'ruby', @env.hi
  end

  def parse src
    l = LineUnit.new @env, src, nil
    l.parse
  end
end
