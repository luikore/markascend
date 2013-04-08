Gem::Specification.new do |s|
  s.name = "markascend"
  s.version = "0.1"
  s.author = "Zete Lui"
  s.homepage = "https://github.com/luikore/markascend"
  s.platform = Gem::Platform::RUBY
  s.summary = "Extensible markdown-like, macro-powered html document syntax and processor"
  s.description = "Extensible markdown-like, macro-powered html document syntax and processor"
  s.required_ruby_version = ">=2.0.0"
  s.license = 'BSD'

  s.files = Dir.glob("{readme,copying,{lib,test}/**/*.rb,Gemfile,rakefile,doc/*.ma}")
  s.require_paths = ["lib"]
  s.rubygems_version = '2.0.3'
  s.has_rdoc = false
end
