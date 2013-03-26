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

NOTE: images are too complex for a naive syntax, it is made into a macro.

h3 headers
|
  h1 title
  h2#anchor-name title

h3 lists

`-` stands for ul
|
  - an entry
  - another entry

`+` stands for ol
|
  + entry 1
  + entry 2

h3 quote

Just one `>` is enough for a quote containing many lines
|
  > Twitter
    can
    input
    new line
    now

h3 escapes
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
entities are supported
|
  &amp;

h3 built-in macros

the following macros explains themselves:
|
  \del{deleted}
  \underline{underline}
  \sub{subscript}
  \sup{supscript}
  \img{hello/a.png alt="an image" href="a.b.c"}
  \html{<hr>}

since we have `html` macro, all tags outside of it will be stripped.

slim is a template engine which makes html much cleaner:
|
  \slim{a href="/" Home}

note that with slim, you can embed a bunch of other template engines, write ruby logic, and do all kinds of evil things:
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

to build a table from a csv
|
  \csv
    name,type
    "Ahri",Mage
    "Miss Fortune",DPS

for block-styled math
|
  \latex
    \begin{align} \\
    & \rm{MathJax}\ \LaTeX \ \rm{Example} \\ \\
    \end{align}

options is a special macro, they are not processed by markascend, but you can get them with API (see below)
|
  \options
    tags: [markascend readme]

to change default syntax for code that without language (details see below):
|
  \hi(rb)
  \hi(none)

to use markascend as a template engine, use the following macros
|
  \ruby{ value of ruby code sanitized }
  \ruby_eval{ ruby code output ignoreed }
  \ruby_raw{ ruby code output raw }

h3 macros notes

macro name should be compatible with ruby method name.

macros can be inline form (`\macro{content}`) or block form (`\macro` and the indented block in next lines is the content of the macro).

Inline macros can use some different delimiters for convinience, allowed ones are: `\macro(content)` and `\macro{content}`.

In the form `\macro(content)`, the content is parsed by lexical rule. The parser handles and only handles 2 escape chars: `\\` and `\)`, very much like single quoted string in Ruby.
Example: `\macro(\ and \\ are both single-backslash. nest: (\))`

In the form `\macro{content}`, you don't escape chars in the content, and can put in recursively nested braces. When you need to put an unmatched `{` or `}` in the content, use the previous form.
Example: `\macro{\\ is two backslashes. nest: {}}`

Design note: There are actual very few symbols left for us... for example `[]`, `$$`, `|` may confuse with link or math or code elements. Symbols like `"`, `'`, `()`, `<>` are not good either, because they are common when composing an article.

NOTE:

- Only 1 block-style macro name is allowed inside a line.
- The basic parsing unit is a line and a block, every parsing starts with this unit --- so don't hand-add space indentations to paragraphs, let css do it.

h3 chart macros

TODO

|
  \d3
  \dot

h3 popular-company macros

to generate a twitter or weibo link
|
  \twitter(@night_song)
  \twitter(#HotS)
  \weibo(@yavaeye)

to generate a wiki link
|
  \wiki[ruby(programing_language)]

embed gist
|
  \gist(12321)

embed video (currently youtube, vimeo, niconico, bilibili and pornhub are supported)
|
  \video(youtube.com/abc)

h3 syntax hilite macros

inline code can also have syntax hiliter

|ma
  \hi(rb)`str.size` in ruby is equivalent to \hi(objc)`str.length` in objc
  |
    this part is also hilited in objc

|
  \hi(none)`\hi(none)` removes hilite state in document
  |
    this part also has no syntax hilite

to specify syntax in block form (this won't change default syntax):
|rb
  puts 'hello world'

h3 combining macro blocks, lists and quotes

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
