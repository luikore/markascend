require_relative "test_helper"

class BuiltinMacrosTest < MarkascendTest
  def setup
    @env = Markascend.build_env({})
  end

  def test_del_underline_sub_sup
    %w[del underline sub sup].each do |x|
      assert_equal "<#{x}>#{x}</#{x}>", parse("\\#{x}(#{x})")
    end
  end

  def test_img
    assert_equal %Q{<img src="src" alt="alt"/>}, parse("\\img(src alt='alt')")
    assert_equal %Q{<a href="href"><img src="src" alt="alt"/></a>}, parse("\\img(src alt='alt' href='href')")
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
    img_tag = %Q|<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF0AAACbBAMAAADy7opZAAAAJ1BMVEX+//8HBwc3Nzc/Pz9/f3+/v79fX18fHx+fn5/f39/T09MAAAD///8iExDGAAAAAXRSTlMAQObYZgAAAppJREFUWIXtmL1u2zAQx/MeHfsKBYKgnfsBZ+uYrBkMd3XRQt06ZEg2G22D+i3kRDJOQ4FEtgXeQ1US9cFv8gzbSAvRgGHQPx7PZ+ru+D9B0vhz8p/yLJyHfmR+XoK0FSrPQPVLnlB43QFlTuI14/q0yFtw6QuRt+Hlgs4lgbfjwoKed+H9go5nhsiIAxTebb6z1/I+863BlveZby02vN98Y7Ll/ThnGj7APIc4H+IOd6jhQ/CacvGPb2y82R2VrzAXr4098MX1j+RuMs1PkzHOv/06O7008EI4GXwYvZrHj1+3MUYZpBfibwCDP4C/M0zqDyyrXh7/K6x8K77T+NEViX9aOv1hKl/vofLG88D5TfoEC7ay8t0sgwyAwX00npzzFC2a2vX8k58v6vNLzQ/k/EPNb+T8Sc3P5PxPri/k+kWtj0itv6Yt3PUdqf0Dhyj9SeuHeXrgB37gB37gB/6IvNK57Z1nptq4Rx534I3z++LZwXlzv2g9D4fmD3g+Sf2VHEgtrCqvhV0JrMwbG1ZpUu5vLT29pb+1hFz6RuBdN4Zuh553XzDaBc9Vzwm430l6jh+X7o/+62Dj8nH0GaIeEuZOr2+EuVNzO/Eh0az5jPOB7legys+nr88r8ad4N3uZTBBnya2Th3S2rMQfBm9f3N5g8Xl+7+RZlnPxBxbRYo3rVRF7+IKLP4A3XxA3AInOg8g34g9gHp0p/2QbHyZOFUkt/pQ2ZjFuVhKv/18s2z7UewB+Kj1bL/GjgRf0sfTnqhZ/ANNtjDm8nwrB088nS5PLPBpPRpA9lP7jdSwIcAY9ynVUjfqSJ8mpz6+DF57f3iFL2e2YHfPPM9SLiPmfXF/I9YtcH8n1F6n1Hcn9A9/jCPqPZfzz/F8Jmm6Wlr09kQAAAABJRU5ErkJggg==" alt="digraph G{main -> parse;}"/>|
    assert_equal img_tag, parse("\\dot(digraph G{main -> parse;})").strip
  end

  def test_options
    parse("\\options(a: [1, 2])")
    assert_equal({"a" => [1, 2]}, @env[:options])
  end

  def test_hi
    parse("\\hi(none)")
    assert_equal 'none', @env[:hi]
  end

  def parse src
    l = LineUnit.new @env, src, nil, 0
    l.parse.join
  end
end
