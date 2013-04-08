\options
  title: Syntax

h1 Design principles

- A simpler *Markdown* should be better.
- Since a markup language usually need to process several different syntaces in one article, language composition becomes important in syntax design.
- TeX macro syntax is nearly perfect for extending the language, but not very visual intuitive when there are too much backslashes and bracers.
- Layout-based grammar (indentation sensitive) shows a cleaner way for language composition and cleaning up macros.

\hi(ma)

h1 Inline elements
*italic*
|
  *italic*

**bold**
|
  **bold**

Italic and bold elements can interpolate
|
  ***bold and italic*bold**

`code` suject to the same rule as in markdown, no escape chars
|
  `code`
  ``to include "`", use more backticks as delimiter``
  `` ` space before and after to disambig backtick number ``

$math$, inside which `\\` and `\$` are treated as atomic elements, no escape chars
|
  $math$
  $\\\$$ <- the content is parsed to latex processer as '\\\$'
  $\\$$ <- NOTE this is a math elem with a pending dollar

Link:
|
  url in lexical parens: [a](example.com/use/\\/for/backslash/and/\)/for/right/paren)
  url in recursive braces: [a]{example.com/allow/{nested{braces}}/and/(parens)/in/url}
  no need to escape backslashes in braces: [a]{file:\\\C:\windows}
  link to anchor: [a](#anchor)

Footnotes:
|
  [.](this is shown in footnote and replaced by a number)
  [.*](this is shown in footnote and replaced by the acronym: *)

Using already defined footnote ("one more dot to use"):
|
  [:1]
  [:link by acronym]

Except math and code, inline elements can be nested.

By default, text starting with `http://`, `https://` or `mailto://` will be auto-linked, you can change supported protocols or disable all with compile options.

NOTE: Not very different from markdown here, just less, math and footnotes added. Images are too complex for a simple syntax, it is made into a macro.

h1 Headers
|
  h1 title
  h2#anchor-name title

NOTE: Anchors are disabled in sandbox mode.
h1 Lists

`-` is the bullet for unordered list
|
  - an entry
  - another entry

`+` is the bullet for ordered list
|
  + entry 1
  + entry 2

h1 Quote

Just one `>` is enough for a quote containing many lines (NOTE: use the similar rule as code block and allow quoter name?)
|
  > You
    can
    input
    new line
    on twitter
    now

h1 Escape characters
|
  \h3
  \\
  \$
  \*
  \[
  \%
  \@
  \#
  ...

All HTML4 entities are supported
|
  &amp;
  &#2382;
  &#x003F;

h1 Built-in macros

The following macros explains themselves:
|
  \del{deleted}
  \underline{underline}
  \sub{subscript}
  \sup{supscript}
  \img{hello/a.png alt="an image" href="a.b.c"}

Unlike in *Mardown*, all html tags in *Markascend* are escaped. If you write
|ma
  <div></div>

You get HTML like this
|html
  &lt;div&gt;&lt;/div&gt;

To put HTML in, you can use the `\html` macro
|
  \html{<hr>}

*Slim* is a template engine which makes html much cleaner:
|
  \slim{a href="/" Home}

Note that with `\slim`, you can embed a bunch of other template engines, or write ruby logic, or do all kinds of evil things:
|
  \slim
    - 3.times do
      markdown:
        # h1 hello world
    sass:
      h1
        color: red
    coffee:
      alert "hello world"

To build a table from a CSV
|
  \csv
    name,type
    "Ahri",Mage
    "Miss Fortune",DPS

A table from CSV, without header
|
  \headless_csv
    "Ahri",Mage
    "Miss Fortune",DPS

For block-styled math
|
  \latex
    \begin{align} \\
    & \rm{MathJax}\ \LaTeX \ \rm{Example} \\ \\
    \end{align}

`\options` is a special macro. The content *YAML* is not processed by *Markascend*, but retrievable with API. This is designed for blogger generators: you can put metadata inside the document.
|
  \options
    tags: [markascend readme]

To change default code syntax highliter (See [below](#syn-hi-macros) for details]:
|
  \hi(rb)
  \hi(none)

h1 Notes on macros

Macro name is case sensitive, starts with a word-character but not digit, and contains no symbols or punctuations. The rule expressed in (Onigmo) regexp is `(?!\d)\w+`. For example, `你2` is valid name, but `2你` is invalid.

Macros can be of inline form (`\macro{content}`) or block form (`\macro` and the indented block in following lines is the content of the macro).

Inline macros can use some different delimiters for convinience, allowed ones are: `\macro(content)` and `\macro{content}`.

In the form `\macro(content)`, the content is parsed by lexical rule. The parser handles and only handles 2 escape chars: `\\` and `\)`, very much like single quoted string in Ruby.
Example: `\macro(\ and \\ are both single-backslash. nest: (\))`

In the form `\macro{content}`, you don't escape chars in the content, and can put in recursively nested braces. When you need to put an unmatched `{` or `}` in the content, use the previous form.
Example: `\macro{\\ is two backslashes. nest: {}}`

Design NOTE: There are actual very few symbols left for us... for example `[]`, `$$`, `|` may confuse with link or math or code elements. Symbols like `"`, `'`, `()`, `<>` are not good either, because they are common when composing an article.

User NOTE:
- The parsing rules for `(content)` and `{content}` are the same as in links.
- Only 1 block-style macro name is allowed inside a line.
- The basic parsing unit is a line and a block, every parsing starts with this unit --- so don't hand-add space indentations to paragraphs, let css do it.

h1 Charting macros

You need to install [graphviz](http://graphviz.org/) first.

|
  \dot
    digraph G{
      main -> parse;
    }

h1 Popular-company macros

This is the transient part but provides some convienience. The list will change if some of them dies before *Markascend*.

To generate a twitter or weibo link
|
  \twitter(@night_song)
  \twitter(#HotS)
  \weibo(@yavaeye)

To generate a wiki link (though wiki is an organization, not a company...)
|
  \wiki{ruby(programing_language)}

Embed gist
|
  \gist(12321)

Embed video (currently should recognize youtube, vimeo and niconico links, the size is a problem)
|
  \video(500x400 http://www.youtube.com/watch?v=TGPvtlnwH6E)
  \video(500x400 http://www.youtube.com/watch?v=TGPvtlnwH6E)
  \video(500x400 http://www.youtube.com/watch?v=TGPvtlnwH6E)

h1#syn-hi-macros Syntax hilite macros and code blocks

Inline code can also have syntax hiliter

|
  \hi(rb)`str.size` in ruby is equivalent to \hi(objc)`str.length` in objc
  |
    this part is also hilited in objc
  \hi(none)`\hi(none)` removes hilite state in document
  |
    this part also has no syntax hilite

To specify syntax in block form (this won't change default syntax):
|
  |rb
    puts 'hello world'

h1 Combining macro blocks, lists and quotes

Lists and quotes are parsed as recursive block elements.
If the inside contains macros, need to indent more for the content of the macro:
|
  > Though the \music macro..
      1232. 1232. 1232.
    is not defined.

Another nesting example:
|
  - an entry
    contains an ordered list
    + entry \latex
        \mathbb{one}
    + entry 2
  - another entry
