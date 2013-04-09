module Markascend
  class Macro
    %w[del underline sub sup].each do |m|
      eval <<-RUBY
        def parse_#{m}
          "<#{m}>\#{::Markascend.escape_html content}</#{m}>"
        end
      RUBY
    end

    def parse_img
      s = ::StringScanner.new content
      unless src = s.scan(/(\\\ |\S)+/)
        env.warn "require src for \\img"
        return
      end
      alt = Macro.scan_attr s, 'alt'
      s.skip /\s+/
      href = Macro.scan_attr s, 'href'
      s.skip /\s+/
      if alt2 = Macro.scan_attr(s, 'alt')
        alt = alt2
      end
      unless s.eos?
        env.warn "parse error for content of \\img"
        return
      end
      (href = ::Markascend.escape_attr href) if href
      alt = ::Markascend.escape_attr alt

      if env.inline_img
        begin
          if env.pwd
            Dir.chdir env.pwd do
              data = open src, 'rb', &:read
            end
          else
            data = open src, 'rb', &:read
          end
          mime = ::Markascend.mime data
          if env.retina
            width, height = ::Markascend.img_size data
            width /= 2.0
            height /= 2.0
            size_attrs = %Q|width="#{width}" height="#{height}" |
          end
          src = "data:#{mime};base64,#{::Base64.strict_encode64 data}"
          inlined = true
        rescue
          env.warn $!.message
        end
      end
      src = ::Markascend.escape_attr src if not inlined

      img = %Q|<img #{size_attrs}src="#{src}" alt="#{alt}"/>|
      if href
        %Q|<a href="#{href}" rel="nofollow">#{img}</a>|
      else
        img
      end
    end

    def parse_html
      if env.sandbox
        ::Markascend.sanitize content
      else
        content
      end
    end

    def parse_slim
      ::Slim::Template.new(){content}.render env.scope
    end

    def parse_csv
      Macro.generate_csv content, false
    end

    def parse_headless_csv
      Macro.generate_csv content, true
    end

    def parse_latex
      %Q|<code class="latex">#{content}</code>|
    end

    def parse_options
      yaml = ::YAML.load(content) rescue nil
      if yaml.is_a?(Hash)
        env.options.merge! yaml
      else
        env.warn '\options content should be a yaml hash'
      end
      ''
    end

    def parse_hi
      # TODO validate syntax name
      env.hi = content == 'none' ? nil : content
      ''
    end

    def parse_dot
      err, out, code = nil
      ::Open3.popen3 'dot', '-Tpng' do |i, o, e, t|
        i.puts content
        i.close
        err = e.read
        out = o.read
        code = t.value.to_i
        e.close
        o.close
      end
      if code != 0
        env.warn err
        return
      end

      width, height = ::Markascend.img_size out
      if env.retina
        width /= 2.0
        height /= 2.0
      end
      data = ::Base64.strict_encode64 out
      %Q|<img width="#{width}" height="#{height}" src="data:image/png;base64,#{data}" alt="#{Markascend.escape_attr content}"/>|
    end

    def Macro.generate_csv content, headless
      rows = ::CSV.parse(content)
      return if rows.empty?

      table = "<table>"
      unless headless
        table << "<thead>"
        head = rows.shift
        head.map!{|e| "<th>#{::Markascend.escape_html e}</th>" }
        table << "<tr>#{head.join}</tr>"
        table << "</thead>"
      end

      table << "<tbody>"
      rows.each do |row|
        row.map!{|e| "<td>#{::Markascend.escape_html e}</td>" }
        table << "<tr>#{row.join}</tr>"
      end
      table << "</tbody></table>"
    end

    def Macro.scan_attr strscan, attr_name
      pos = strscan.pos
      strscan.skip /\s+/
      unless strscan.peek(attr_name.size) == attr_name
        strscan.pos = pos
        return
      end
      strscan.pos += attr_name.size

      if strscan.scan(/\s*=\s*/)
        # http://www.w3.org/TR/html5/syntax.html#attributes-0
        if v = strscan.scan(/(["']).*?\1/)
          v[1...-1]
        else
          strscan.scan(/\w+/)
        end
      else
        attr_name
      end
    end
  end
end
