def activate_url url
  Thread.new do
    system "open", url
  end
end
