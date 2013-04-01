h3 Compile

|ruby
  Markascend.compile src, options

h3 Options

- `:autolink`, default value is `%w[http https ftp mailto]`
- `:inline_img`, compile image into inlined base64, default = `false`
- `:macros`, the value can be
  - `nil`(default), which means using standard macros only.
  - An array (unordered) telling the names of enabled macros.
- `:line_units`, the value can be
  - `nil`(default), which means using standard line-unit parsers only.
  - An array (ordered) telling the names of enabled parsers.

TODO sandbox options

h3 Customizing macros

More macro processors can be added by

|ruby
  class Markascend::Macro
    def parse_fancy_macro
      ... compose result string with: env, content, inline
    end
  end

Macro names are limited to names like ruby methods.

|ruby
  Markascend.compile src, macros: %w[fancy_macro del]

h3 Customizing line-unit parsers

More line-unit parsers can be added by

|ruby
  class Markascend::LineUnit
    def parse_at
      ... compose result string with: env, line, block, linenum
    end
  end

The list of inline parsers can be changed, or reordered

|ruby
  Markascend.compile src, line_units: Markascend::DEFAULT_LINE_UNITS + %w[at]

h3 Notes on `\slim`

You need to install slim (`gem ins slim`) and require it before using the `\slim` macro:

|ruby
  require 'slim'

h3 Notes on `\dot`

You need to install [graphviz](graphviz.org) before using the `\dot` macro.

h3 Notes on `\