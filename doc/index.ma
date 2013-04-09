h1 Introduction

Markascend is an extensible markdown-like, macro-powered html document syntax and processor.
Can be used as blog-generator, post-formatter or for literate programing.

The generated output is HTML segment, but not XML.

h1 Requirement

Requires CRuby 2.0.0+ and libmagic. JRuby and Rubinius won't work due to some known issues.

To install libmagic on Ubuntu
|sh
  sudo apt-get install libmagic-dev

To install libmagic on Mac
|sh
  brew install libmagic

If you want to use the \hi(ma)`\dot` macro, you need to install [graphviz](graphviz.org).

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
