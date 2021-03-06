def osascript src
  IO.popen 'osascript', 'r+' do |f|
    f.puts src
    f.close_write
    f.read
  end
end

def get_default_browser
  # search handler for http
  res = osascript <<-APPLESCRIPT
  tell (system attribute "sysv") to set MacOS_version to it mod 4096 div 16
  if MacOS_version is 5 then
    set {a1, a2} to {1, 2}
  else
    set {a1, a2} to {2, 1}
  end if
  set pListpath to (path to preferences as Unicode text) & "com.apple.LaunchServices.plist"
  tell application "System Events"
    repeat with i in property list items of property list item 1 of contents of property list file pListpath
      if value of property list item a2 of i is "http" then
        return value of property list item a1 of i
      end if
    end repeat
    return "com.apple.Safari"
  end tell
  APPLESCRIPT
  case res
  when /canary/
    "Google Chrome Canary"
  when /chrome/
    "Google Chrome"
  when /safari/
    "Safari"
  else
    raise "browser not supported yet"
  end
end

# [window, tab]
def search_tab_with_url browser, url
  case browser
  when /Chrome/
    res = osascript <<-APPLESCRIPT
    set urls to ""
    tell application "#{browser}"
      set i to 1
      repeat with w in windows
        set j to 1
        repeat with t in (tabs of w)
          set u to the URL of t
          set u to (i as text) & "," & (j as text) & u
          set urls to urls & u & return
          set j to j + 1
        end repeat
        set i to i + 1
      end repeat
    end tell
    return urls
    APPLESCRIPT
  when /Safari/
    # URL is not set when loading, so need a stupid null testing
    res = osascript <<-APPLESCRIPT
    set urls to ""
    tell application "Safari"
      set i to 1
      repeat with w in windows
        set j to 1
        repeat with t in (tabs of w)
          set u to the URL of t
          set isNull to false
          try
            get u
          on error
            set isNull to true
          end try
          if isNull then
          else
            set u to (i as text) & "," & (j as text) & u
            set urls to urls & u & return
          end if
          set j to j + 1
        end repeat
        set i to i + 1
      end repeat
    end tell
    return urls
    APPLESCRIPT
  end
  res.strip.split(/[\r\n]+/).each do |u|
    if u.index url
      /^(?<window>\d+),(?<tab>\d+)/ =~ u
      return [window, tab]
    end
  end
  nil
end

def activate_url url
  browser = get_default_browser
  window, tab = search_tab_with_url browser, url
  url.gsub! '"', '\"'
  if tab # activate existing doc
    case browser
    when /Chrome/
      osascript <<-APPLESCRIPT
      tell application "#{browser}"
        activate
        set active tab index of window #{window} to #{tab}
        reload tab #{tab} of window #{window}
      end tell
      APPLESCRIPT
    when /Safari/
      osascript <<-APPLESCRIPT
      tell application "#{browser}"
        activate
        tell window #{window} to set current tab to tab #{tab}
        set the url of the front document to "#{url}"
      end tell
      APPLESCRIPT
    end
  else # open new doc
    case browser
    when /Chrome/
      # NOTE some user sets handler for .html to editor than browser
      #      so we don't use `open` command here
      osascript <<-APPLESCRIPT
      tell application "#{browser}"
        activate
        make new tab at the end of tabs of window 1
        set the URL of active tab of window 1 to "#{url}"
      end tell
      APPLESCRIPT
    when /Safari/
      osascript <<-APPLESCRIPT
      tell application "#{browser}"
        activate
        make new document at the end of documents
        set the url of the front document to "#{url}"
      end tell
      APPLESCRIPT
    end
  end
end
