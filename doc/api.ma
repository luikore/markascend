\hi(ruby)
h2 Compile

|
  Markascend.compile src, options

h2 Options

- `:autolink`, default value is `%w[http https ftp mailto]`
- `:inline_img`, compile image into inlined base64, default = `false`
- `:macros`, specify the names of enabled macros. Other macros will be treated as plain text. The default value is `Markascend::DEFAULT_MACROS`.
- `:line_units`, specify the inline parsers to be used (be careful with the order!). The default value is `Markascend::DEFAULT_LINE_UNITS`.
- `:sandbox`, a hybrid option to tweak the syntax to be generally safe for user inputs. `false` by default. When set to `true`, footnotes are disabled, header anchors are ignored, and enabled macros are set to `Markascend::SANDBOX_MACROS`. The sandbox macro list can be overriden by the `:macros` option.
- `:toc`, whether generate table of contents. `false` by default.

h2 Customizing macros

More macro processors can be added by

|
  class Markascend::Macro
    def parse_fancy_macro
      ... compose result string with: env, content, inline
    end
  end

Macro names are limited to names like ruby methods.

|
  Markascend.compile src, macros: %w[fancy_macro del]

h2 Customizing line-unit parsers

More line-unit parsers can be added by

|
  class Markascend::LineUnit
    def parse_at
      ... compose result string with: env, line, block, linenum
    end
  end

The list of inline parsers can be changed, or reordered

|
  Markascend.compile src, line_units: Markascend::DEFAULT_LINE_UNITS + %w[at]

h2 Notes on `\slim`

You need to install slim \hi(bash)(`gem ins slim`) and require it before using the \hi(ma)`\slim` macro:
\hi(ruby)
|
  require 'slim'

It is disabled in sandbox mode.

h2 Notes on `\dot`

You need to install [graphviz](graphviz.org) before using the \hi(ma)`\dot` macro.

It is disabled in sandbox mode.

h2 Notes on output format

The output is valid HTML5, but not XHTML.
