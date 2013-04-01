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
    img_tag = %Q|<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF0AAACbCAYAAAAAwJdqAAAVJElEQVR4Ae2dB/AT1RPHH/aKHQULFsSGFBV7Q0Gxi12wKzoqIo4FFOuoiDpYEEXHCjJ2sTMWiqBgw4bYBVTs2Hvf/352/i+GX3LJXXLJJeF2Jr/75XKv3Pf23tu3u2+3mSi5lKqKwHxVbS1tzBBIQU+AERZIoM1ITf7555/uq6++ss+vv/7qfv/9d/v88ccfbsEFF3SLLLKIW3jhhe243HLLuRVXXNEtueSSkdqo9sU1ATrAvv766+6tt95y77zzjn3ef/999/nnn7tvv/02MiaLLbaYgb/mmmu6ddddN/PZaKON3LLLLhu5vrgLNEtiIv3ll1/cuHHj3MSJE93zzz/vXn75ZQfnLrroom7ttdd266yzjn1WXnllA2+llVZyLVq0cIsvvniGs+Huv//+O8P1v/32m/v666/dl19+aZ8vvvjC8eDeffdd+/Bbs2bNXNu2bd3mm2/uttpqK9e9e3e36qqrxo1p0fqqBjpce++997rHHnvMwIa7O3ToYAAAAh8AAZhKEEPUiy++aA+ZB/3cc885hqsNN9zQ7brrrm6//fZzm2yySSWazq0TTq8UKffJHXfcIcpRMv/888tSSy0lBx54oIwYMUKUEyvVbKh6dW6QJ554Qvr16ydt2rRBbJb11ltPBg0aJLNnzw5VR6kXuVILFio3Z84cOf/882WFFVYQnexkjz32kHvuuUd4CLVKyv3Sp08fWX755WWBBRaQnj17ig57FelurKDruCknn3yy6NgsKknIwIEDRYeVinS8UpXq3GJvYseOHY37u3btKi+99FKszcUCOq/q4MGDbfhQkU2uueYa0fEy1o4mUdnYsWNliy22EJ1n5OCDD5YPP/wwlm6UDTqvJWOhShY2pPz000+xdKyWKhk9erSoRGX3OHToUPn333/L6l7JoP/111/Sv39/myC7desWGxeUdTcVLMywc/bZZ9scte2228pHH31Ucmslgc5E2aVLF9FFiNx0000lN16PBV977TVZf/31TUjQdUZJtxAZ9LfffltWX311WWONNYQOzIvEELrvvvsa1998882RIYgEui7TRVeHogsZ+eabbyI31mgFGG6YZK+//vpItxYadF1SC5LJ1ltvLT/++GOkRhr54osuusiAj8LxoUD/+eefpV27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" alt="digraph G{main -> parse;}"/>|
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
