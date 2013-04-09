\hi(ruby)
h1 Compile

|
  Markascend.compile src, options

h1 Options

- `:path`, source file path. Used for static files lookup. If not given, use the current working directory.
- `:autolink`, default value is `%w[http https ftp mailto]`
- `:inline_img`, compile image into inlined base64, default = `false`
- `:macros`, specify the names of enabled macros. Other macros will be treated as plain text. The default value is `Markascend::DEFAULT_MACROS`.
- `:line_units`, specify the inline parsers to be used (be careful with the order!). The default value is `Markascend::DEFAULT_LINE_UNITS`.
- `:sandbox`, a hybrid option to tweak the syntax to be generally safe for user inputs. `false` by default. When set to `true`, footnotes are disabled, header anchors are ignored, and enabled macros are set to `Markascend::SANDBOX_MACROS`. The sandbox macro list can be overriden by the `:macros` option.
- `:toc`, whether generate table of contents. `false` by default. Header anchors can be customized or generated in the form of `"-#{N}"`. Note that there's no "permalink" generator for headers, but you can implement one with simple javascript.
- `:retina`, whether treat `\img` and `\dot` outputs as half the size. `false` by default.
  When retina is turned on, graphs may look smaller, you can add instructions to increase dpi to get more pixels to make the size fit:
  |dot
    graph [ dpi = 264 ]; // 132 for normal display

h1 Customizing macros

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

h1 Customizing line-unit parsers

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
