h3 Design principles

- I love markdown but feel some little flaws, a simpler markdown should be better.
- Since a markup language usually need to process several different syntaces in one article, language composition becomes important in syntax design.
- TeX macro syntax is nearly perfect for extending the language, but not very visual intuitive when there are too much backslashes and bracers.
- Layout-based grammar (indentation sensitive) can make a cleaner way for language composition.

\hi(ma)

h3 Inline elements
*italic*
|
  *italic*

**bold**
|
  **bold**

`code`
|
  `code`

$math$
|
  $math$

Link:
|
  [a](href)

Link to anchor:
|
  [#anchor]

Footnotes:
|
  [.this is shown in footnote and replaced by a number]
  [.this is shown in footnote and replaced by the acronym after pipe | \*]

Using already defined footnote (one dot is define, two dots is reference):
|
  [:1]
  [:link by acronym]

Except math and code, inline elements can be nested.

By default, text starting with `http://`, `https://` or `mailto://` will be auto-linked, you can change supported protocols or disable all with compile options.

NOTE: Not very different from markdown here, just less, math and footnotes added. Images are too complex for a simple syntax, it is made into a macro.

h3 Headers
|
  h1 title
  h2#anchor-name title

NOTE: Anchors are disabled in sandbox mode.
h3 Lists

`-` is the bullet for unordered list
|
  - an entry
  - another entry

`+` is the bullet for ordered list
|
  + entry 1
  + entry 2

h3 Quote

Just one `>` is enough for a quote containing many lines
|
  > You
    can
    input
    new line
    on twitter
    now

h3 Escape characters
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

h3 Built-in macros

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

Slim is a template engine which makes html much cleaner:
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

For block-styled math
|
  \latex
    \begin{align} \\
    & \rm{MathJax}\ \LaTeX \ \rm{Example} \\ \\
    \end{align}

`\options` is a special macro. The content *YAML* is not processed by *Markascend*, but retrievable with API. This is designed for the purpose of blogger generators.
|
  \options
    tags: [markascend readme]

To change default code syntax highliter (See [#syn-hi-macros](below) for details]:
|
  \hi(rb)
  \hi(none)

h3 Notes on macros

Macro name is case sensitive, starts with a word-character but not digit, and contains no symbols or punctuations. The rule expressed in (Onigmo) regexp is `(?!\d)\w+`. For example, `你2` is valid, but `2你` is invalid.

Macros can be of inline form (`\macro{content}`) or block form (`\macro` and the indented block in following lines is the content of the macro).

Inline macros can use some different delimiters for convinience, allowed ones are: `\macro(content)` and `\macro{content}`.

In the form `\macro(content)`, the content is parsed by lexical rule. The parser handles and only handles 2 escape chars: `\\` and `\)`, very much like single quoted string in Ruby.
Example: `\macro(\ and \\ are both single-backslash. nest: (\))`

In the form `\macro{content}`, you don't escape chars in the content, and can put in recursively nested braces. When you need to put an unmatched `{` or `}` in the content, use the previous form.
Example: `\macro{\\ is two backslashes. nest: {}}`

Design NOTE: There are actual very few symbols left for us... for example `[]`, `$$`, `|` may confuse with link or math or code elements. Symbols like `"`, `'`, `()`, `<>` are not good either, because they are common when composing an article.

User NOTE:
- Only 1 block-style macro name is allowed inside a line.
- The basic parsing unit is a line and a block, every parsing starts with this unit --- so don't hand-add space indentations to paragraphs, let css do it.

h3 Charting macros

TODO
|
  \d3
  \dot

h3 Popular-company macros

This is the transient part but provides some convienience. The list will change if some of them dies before *Markascend*.

To generate a twitter or weibo link
|
  \twitter(@night_song)
  \twitter(#HotS)
  \weibo(@yavaeye)

To generate a wiki link
|
  \wiki[ruby(programing_language)]

Embed gist
|
  \gist(12321)

Embed video (currently should recognize youtube, vimeo and niconico)
|
  \video(youtube.com/abc)

h3#syn-hi-macros Syntax hilite macros

Inline code can also have syntax hiliter

|
  \hi(rb)`str.size` in ruby is equivalent to \hi(objc)`str.length` in objc
  |
    this part is also hilited in objc
  \hi(none)`\hi(none)` removes hilite state in document
  |
    this part also has no syntax hilite

To specify syntax in block form (this won't change default syntax):
|rb
  puts 'hello world'

h3 Combining macro blocks, lists and quotes

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
