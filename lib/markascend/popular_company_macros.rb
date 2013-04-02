module Markascend
  # video

  class Macro
    # accepts:
    # |
    #   @somebody
    def parse_twitter
      if content.start_with?('@')
        text = ::Markascend.escape_html content
        link = "https://twitter.com/#{::Markascend.escape_attr content[1..-1]}"
      else
        # TODO embed tweet
        raise 'not implemented yet'
      end
      %Q{<a href="#{link}">#{text}</a>}
    end

    # accepts:
    # |
    #   @somebody
    def parse_weibo
      if content.start_with?('@')
        text = ::Markascend.escape_html content
        link = "https://weibo.com/#{::Markascend.escape_attr content[1..-1]}"
      else
        # TODO embed tweet
        raise 'not implemented yet'
      end
      %Q{<a href="#{link}">#{text}</a>}
    end

    def parse_wiki
      %Q|<a href="http://en.wikipedia.org/wiki/#{content}">#{content}</a>|
    end

    # embed gist, accepts:
    # |
    #   luikore/737238
    #   gist.github.com/luikore/737238
    #   https://gist.github.com/luikore/737238
    def parse_gist
      src = content.strip
      if src =~ /\A\w+(\-\w+)*\/\d+/
        src = "https://gist.github.com/#{src}"
      else
        src.sub! /\A(?=gist\.github\.com)/, 'https://'
      end
      src.sub!(/((?<!\.js)|\.git)$/, '.js')
      %Q|<script src="#{src}"></script>|
    end

    # embed video, calculates embed iframe by urls from various simple formats, but not accept iframe code
    def parse_video
      # standard
      unless /\A\s*(?<width>\d+)x(?<height>\d+)\s+(?<url>.+)\z/ =~ content
        env.warn 'can not parse \video content, should be "#{WIDTH}x#{HEIGHT} #{URL}"'
        return
      end

      case url
      when /youtu\.?be/
        # NOTE merging them into one regexp fails (because longest match?)
        unless id = url[/(?<=watch\?v=)\w+/] || url[/(?<=embed\/)\w+/] || url[/(?<=youtu\.be\/)\w+/]
          env.warn 'can not parse youtube id'
          return
        end
        %Q|<iframe width="#{width}" height="#{height}" src="https://www.youtube-nocookie.com/embed/#{id}?rel=0" frameborder="0" allowfullscreen></iframe>|
      when /vimeo/
        unless id = url[/(?<=vimeo\.com\/)\w+/]
          env.warn 'can not parse vimeo id, should use link like this "http://vimeo.com/#{DIGITS}"'
          return
        end
        %Q|<iframe width="#{width}" height="#{height}" src="https://player.vimeo.com/video/#{id}" frameborder="0" allowFullScreen></iframe>|
      when /sm/
        unless id = url[/\bsm\d+/]
          env.warn 'can not find "sm#{DIGITS}" from link'
          return
        end
        %Q|<script src="https://ext.nicovideo.jp/thumb_watch/#{id}?w=#{width}&h=#{height}"></script>"|
      else
        env.warn 'failed to parse video link, currently only youtube, vimeo and niconico are supported'
        return
      end
    end
  end
end
