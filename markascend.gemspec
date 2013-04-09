Gem::Specification.new do |s|
  s.name = "markascend"
  s.version = "0.2"
  s.author = "Zete Lui"
  s.homepage = "https://github.com/luikore/markascend"
  s.platform = Gem::Platform::RUBY
  s.summary = "Extensible markdown-like, macro-powered html document syntax and processor"
  s.description = "Extensible markdown-like, macro-powered html document syntax and processor"
  s.required_ruby_version = ">=2.0.0"
  s.add_runtime_dependency 'ruby-filemagic'
  s.add_runtime_dependency 'slim'
  s.add_runtime_dependency 'pygments.rb'
  s.add_runtime_dependency 'dimensions'
  s.add_runtime_dependency 'sanitize'
  s.license = 'BSD'

  s.files = Dir.glob("{readme,copying,{lib,test}/**/*.rb,Gemfile,rakefile,doc/*.ma}")
  s.require_paths = ["lib"]
  s.rubygems_version = '2.0.3'
  s.has_rdoc = false
end
