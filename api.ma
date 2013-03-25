h3 compile

|ruby
  Markascend.compile src, options

h3 compile options

- `:autolink`, default = `%w[http https ftp mailto]`
- `:enabled_macros`, default = `:all`
  You can choose what macros are allowed and what are not by setting a white list:
  |ruby
    enabled_macros: :all # the default is to enable all
    Markascend.compile post_from_other_people
- `:inline_img`, compile image into inlined base64, default = `false`

h3 adding macros

macro names are limited to names like ruby methods.

TODO

h3 extending the parser

The parser can also be extended with regular expression. For example, an extension to make `@` macros.

TODO
