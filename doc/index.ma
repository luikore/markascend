h1 Introduction

Markascend is an extensible markdown-like, macro-powered html document syntax and processor.
Can be used as blog-generator, post-formatter or for literate programing.

The generated output is HTML segment, but not XML.

h1 Requirements

Requires CRuby 2.0.0+, [libmagic](http://www.darwinsys.com/file/) and [libxml2](http://xmlsoft.org). JRuby or Rubinius won't work due to some known issues.

To install dependencies on Ubuntu
|sh
  sudo apt-get install libmagic-dev libxml2-dev

To install dependencies on Mac OS X
|sh
  brew install libmagic
  brew install ilbxml2

If you want to use the \hi(ma)`\dot` macro, you need to install [graphviz](graphviz.org).

Ubuntu:
|sh
  sudo apt-get install graphviz

Mac OS X
|sh
  sudo apt-get install graphviz

h1 Install

|sh
  gem ins markascend

h1 Cheat Sheet

TODO

h1 Document

- [Syntax in Details](syntax.html)
- [API in Details](api.html)
- [Editor Support (Textmate/Sublime)](https://github.com/luikore/Markascend.tmbundle)

h1 License

[BSD](https://github.com/luikore/markascend/tree/master/copying)
