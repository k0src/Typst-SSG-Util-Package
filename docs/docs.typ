#import "@preview/fontawesome:0.6.0": *

// Page Setup

#let font = "PT Sans"
#let mono-font = "JetBrains Mono"

#set page(
  paper: "us-letter",
  margin: (top: 6em, right: 6em, bottom: 6em, left: 6em),
)

#set text(
  font: font,
  size: 11pt,
  fill: rgb("#1a1a1a"),
)

#show raw: set text(font: mono-font)

#set heading(numbering: none)

#show heading: it => {
  set block(below: 1em)
  it
}

#show link: it => underline(text(fill: rgb("#2980b9"))[#it])

// Package Functions

#let _base-url = state("site-link-base", "")

#let set-base(url) = {
  let clean-url = if url.ends-with("/") {
    url.slice(0, -1)
  } else {
    url
  }
  _base-url.update(clean-url)
}

#let site-link(dest, ..body-args, same-tab: false) = context {
  let base = _base-url.get()

  let full-dest = if base != "" and type(dest) == str {
    base + dest
  } else {
    dest
  }

  let actual-dest = if same-tab and type(full-dest) == str {
    full-dest
  } else {
    full-dest
  }

  if body-args.pos().len() == 0 {
    if same-tab and type(full-dest) == str {
      link(actual-dest, full-dest)
    } else {
      link(actual-dest)
    }
  } else {
    link(actual-dest, body-args.pos().at(0))
  }
}

#let reading-time(content, words-per-minute: 200) = {
  let text = if type(content) == str {
    content
  } else {
    repr(content)
  }

  let words = text.split(regex("\\s+")).filter(w => w.len() > 0)
  let word-count = words.len()

  let minutes = calc.ceil(word-count / words-per-minute)

  if minutes <= 60 {
    if minutes == 1 {
      return "1 min read"
    } else {
      return str(minutes) + " min read"
    }
  } else {
    let hours = calc.round(minutes / 60)
    if hours == 1 {
      return "1 hour read"
    } else {
      return str(hours) + " hour read"
    }
  }
}

#let divider(
    space-before: 0.5em,
    space-after: 0.5em,
    stroke: 0.5pt + rgb("#ddd"),
  ) = {
  v(space-before)
  line(length: 100%, stroke: stroke)
  v(space-after)
}

#let format-date(day, month, year) = {
  let months = (
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  )

  return months.at(month - 1) + " " + str(day) + ", " + str(year)
}

#let c(code, lang: "text", styles: none) = {
  let default-styles = (
    fill: rgb("#f5f5f5"),
    inset: (x: 0.3em, y: 0em),
    outset: (y: 0.3em),
    radius: 0.15em,
    text-color: rgb("#333"),
  )

  let s = if styles == none {
    default-styles
  } else {
    default-styles + styles
  }

  box(
    fill: s.fill,
    stroke: none,
    inset: s.inset,
    outset: s.outset,
    radius: s.radius,
    if s.text-color != none {
      text(fill: s.text-color)[#raw(code, lang: lang)]
    } else {
      [#raw(code, lang: lang)]
    },
  )
}

#let code-block(code, styles: none) = {
  let code-text = if type(code) == str {
    code
  } else {
    code.text
  }
  
  let lang = if type(code) != str and code.has("lang") {
    code.lang
  } else {
    none
  }
  
  let default-styles = (
    fill: rgb("#f5f5f5"),
    stroke: 0.5pt + rgb("#ddd"),
    radius: 0.2em,
    icon-color: rgb("#333"),
    text-color: none,
    inset: 1em,
  )
  
  let s = if styles == none {
    default-styles
  } else {
    default-styles + styles
  }
  
  block(
    width: 100%,
    inset: s.inset,
    radius: s.radius,
    fill: s.fill,
    stroke: s.stroke,
    breakable: false,
    {
      if s.text-color != none {
        text(fill: s.text-color)[#code]
      } else {
        [#code]
      }
      place(
        top + right,
        link(
          "#",
          box(
            inset: (x: 0.4em, y: 0.35em),
            radius: 0.15em,
            fill: s
              .at(
                "icon-color",
                default: s.at(
                  "text-color",
                  default: rgb("#333"),
                ),
              )
              .transparentize(90%),
            stroke: 0.5pt
              + s
                .at(
                  "icon-color",
                  default: s.at(
                    "text-color",
                    default: rgb("#333"),
                  ),
                )
                .transparentize(70%),
            text(
              size: 0.8em,
              fill: s.at(
                "icon-color",
                default: s.at(
                  "text-color",
                  default: rgb("#333"),
                ),
              ),
            )[
              #fa-icon("copy")
            ],
          ),
        ),
      )
    },
  )
}

// Markup Functions

#let rainbow-map = (
  (rgb("#7cd5ff"), 0%),
  (rgb("#a6fbca"), 33%),
  (rgb("#fff37c"), 66%),
  (rgb("#ffa49d"), 100%),
)

#let gradient-for-color-types = gradient.linear(angle: 7deg, ..rainbow-map)
#let gradient-for-tiling = (
  gradient
    .linear(
      angle: -45deg,
      rgb("#ffd2ec"),
      rgb("#c6feff"),
    )
    .sharp(2)
    .repeat(5)
)

#let default-type-color = rgb("#eff0f3")

#let colors = (
  "default": default-type-color,
  "content": rgb("#a6ebe6"),
  "string": rgb("#d1ffe2"),
  "str": rgb("#d1ffe2"),
  "none": rgb("#ffcbc4"),
  "auto": rgb("#ffcbc4"),
  "bool": rgb("#ffedc1"),
  "boolean": rgb("#ffedc1"),
  "integer": rgb("#e7d9ff"),
  "int": rgb("#e7d9ff"),
  "float": rgb("#e7d9ff"),
  "ratio": rgb("#e7d9ff"),
  "length": rgb("#e7d9ff"),
  "angle": rgb("#e7d9ff"),
  "relative length": rgb("#e7d9ff"),
  "relative": rgb("#e7d9ff"),
  "fraction": rgb("#e7d9ff"),
  "symbol": default-type-color,
  "array": default-type-color,
  "dictionary": default-type-color,
  "arguments": default-type-color,
  "selector": default-type-color,
  "module": default-type-color,
  "stroke": default-type-color,
  "function": rgb("#f9dfff"),
  "color": gradient-for-color-types,
  "gradient": gradient-for-color-types,
  "tiling": gradient-for-tiling,
)

#let show-type(type, style-args: (:)) = {
  h(2pt)
  let clr = style-args.colors.at(
    type,
    default: style-args.colors.at(
      "default",
      default: default-type-color,
    ),
  )
  box(
    outset: 2pt,
    fill: clr,
    radius: 2pt,
    raw(type, lang: none),
  )
  h(2pt)
}

#let alert(body, color: rgb("#239dad")) = {
  block(
    width: 100%,
    fill: color.lighten(75%),
    inset: (left: 1em, rest: 1em),
    stroke: (left: 3pt + color),
    breakable: false,
    body
  )
}

#let func-def(title, desc) = {
  [
    == #sym.arrow.r.curve #c(title)
    #desc
    #v(0.5em)
  ]
}

#let func-ex(code, res: none) = {
  [*Example:*]
  
  if res == none {
    block(
      width: 100%,
      inset: 1em,
      radius: 0.2em,
      fill: rgb("#f8f8f8"),
      stroke: 0.05em + rgb("#c8c8c8"),
      breakable: false,
      {
        set text(size: 0.9em)
        code
      },
    )
  } else {
    layout(size => context {
      let code-width = (size.width - 0.5em) / 2

      let left-size = measure(block(
        width: code-width,
        inset: 1em,
        radius: 0.2em,
        fill: rgb("#f8f8f8"),
        stroke: 0.05em + rgb("#c8c8c8"),
        breakable: false,
        {
          set text(size: 0.9em)
          code
        },
      ))

      let right-size = measure(block(
        width: code-width,
        inset: 1em,
        radius: 0.2em,
        fill: rgb("#f5fafc"),
        stroke: 0.05em + rgb("#bfd9ea"),
        breakable: false,
        {
          set text(size: 0.9em)
          res
        },
      ))

      let min-height = calc.max(left-size.height, right-size.height)

      grid(
        columns: 2,
        gutter: 0.5em,
        block(
          width: 100%,
          height: min-height,
          inset: 1em,
          radius: 0.2em,
          fill: rgb("#f8f8f8"),
          stroke: 0.05em + rgb("#c8c8c8"),
          breakable: false,
          {
            set text(size: 0.9em)
            code
          },
        ),
        block(
          width: 100%,
          height: min-height,
          inset: 1em,
          radius: 0.2em,
          stroke: 0.05em + rgb("#c8c8c8"),
          breakable: false,
          {
            set text(size: 0.9em)
            res
          },
        ),
      )
    })
  }
}

#let func-params(func-name, params: (:)) = {
  [*Parameters*]
  block(
    width: 100%,
    {
      pad(x: 1em, {
        set text(font: mono-font, size: 0.9em)
        text(func-name, fill: rgb("#4b69c6"))
        "("

        let param-keys = params.keys()
        for (i, param-name) in param-keys.enumerate() {
          let param-info = params.at(param-name)

          linebreak()
          h(1em)
          param-name
          ": "

          let type-list = if type(param-info.types) == str {
            (param-info.types,)
          } else {
            param-info.types
          }

          for (j, type) in type-list.enumerate() {
            show-type(type, style-args: (colors: colors))
            if j < type-list.len() - 1 { " " }
          }

          if param-info.default != none {
            " = "
            raw(repr(param-info.default), lang: none)
          }

          if i < param-keys.len() - 1 { "," }
        }

        linebreak()
        ")"
      })
    },
  )

  for param-name in params.keys() {
    let param-info = params.at(param-name)

    block(
      width: 100%,
      fill: rgb("#f8f8f8"),
      inset: 1em,
      radius: 0.2em,
      breakable: true,
      {
        [*#raw(param-name)*]
        h(1em)
        let type-list = if type(param-info.types) == str {
          (param-info.types,)
        } else {
          param-info.types
        }
        for type in type-list {
          [#show-type(type, style-args: (colors: colors)) ]
        }

        linebreak()
        v(0.05em)

        param-info.desc

        if param-info.default != none {
          linebreak()
          v(0.05em)
          [Default: #raw(repr(param-info.default))]
        }

        if "dict-fields" in param-info {
          linebreak()
          v(0.05em)
          for field in param-info.dict-fields {
            [#raw(field.name)]
            ": "
            let field-types = if type(field.types) == str {
              (field.types,)
            } else {
              field.types
            }
            for field-type in field-types {
              [#show-type(field-type, style-args: (colors: colors)) ]
            }
            linebreak()
            h(1em)
            field.desc
            linebreak()
            v(0.05em)
          }
        }
      },
    )
  }
}

// Docs

= Typst SSG Util Package

#outline(title: none, depth: 2)

#func-def("c", "Renders inline code with syntax highlighting options.")

#func-ex(
  raw(
    "Inline #c(\"code\") example\n\nWith syntax highlighting: #c(\"console.log(\\\"Hello\\\");\", lang: \"js\")",
    lang: "typ",
    block: true,
  ),
  res: [
    Inline #c("code") example

    With syntax highlighting: #c("console.log(\"Hello\");", lang: "js")
  ],
)

#func-params(
  "c",
  params: (
    "code": (
      desc: "The code content to display.",
      types: ("str", "content"),
      default: none,
    ),
    "lang": (
      desc: "The language for syntax highlighting.",
      types: "str",
      default: "text",
    ),
    "styles": (
      desc: "Custom styles for the inline code.",
      types: "dictionary",
      default: none,
      dict-fields: (
        (
          name: "fill",
          types: ("color", "gradient"),
          desc: "Background fill color.",
        ),
        (
          name: "inset",
          types: "dictionary",
          desc: [Inner padding with `x` (length) and `y` (length).],
        ),
        (
          name: "outset",
          types: "dictionary",
          desc: [Outer spacing with `x` (length) and `y` (length).],
        ),
        (
          name: "radius",
          types: "length",
          desc: "Corner radius.",
        ),
        (
          name: "text-color",
          types: "color",
          desc: "Text color for the code.",
        ),
      ),
    ),
  ),
)

#divider()

#func-def("code-block", [Renders a styled code block with a copy button. Generates a custom link that is processed by the Typst SSG package that copies the `code` content to the clipboard.])

#func-ex(
  raw(
"#code-block(
  ```js
  function greet(name) {
    console.log(`Hello, ${name}!`);
  }

  greet(\"World\");
  ```
)",
    lang: "typ",
    block: true,
  ),
  res: [
    #code-block(
      ```js
      function greet(name) {
        console.log(`Hello, ${name}!`);
      }

      greet("World");
      ```
    )
  ],
)

#func-params(
  "code-block",
  params: (
    "code": (
      desc: "The code content to display.",
      types: ("str", "content"),
      default: none,
    ),
    "styles": (
      desc: "Custom styles for the inline code.",
      types: "dictionary",
      default: none,
      dict-fields: (
        (
          name: "fill",
          types: ("color", "gradient"),
          desc: "Background fill color.",
        ),
        (
          name: "stroke",
          types: ("auto", "color", "gradient"),
          desc: "Border stroke color and width.",
        ),
        (
          name: "inset",
          types: "dictionary",
          desc: [Inner padding with `x` (length) and `y` (length)],
        ),
        (
          name: "radius",
          types: "length",
          desc: "Corner radius.",
        ),
        (
          name: "text-color",
          types: ("color", "gradient"),
          desc: "Text color for the code.",
        ),
        (
          name: "icon-color",
          types: ("color", "gradient"),
          desc: "Color for the copy icon.",
        ),
      ),
    ),
  ),
)

#divider()

#func-def("divider", "Renders a horizontal divider with spacing.")

#func-ex(
  raw(
"Hello
#divider(space-before: 0.1em, space-after: 0.1em)
World",
    lang: "typ",
    block: true,
  ),
  res: [
    Hello
    #divider(space-before: 0.1em, space-after: 0.1em)
    World
  ],
)

#func-params(
  "divider",
  params: (
    "space-before": (
      desc: "Space before the divider.",
      types: "length",
      default: 0.5em,
    ),
    "space-after": (
      desc: "Space after the divider.",
      types: "length",
      default: 0.5em,
    ),
    "stroke": (
      desc: "Divider stroke color and width.",
      types: ("auto", "color", "gradient"),
      default: 0.5pt + rgb("#ddd"),
    ),
  ),
)

#divider()

#func-def("format-date", "Formats a date given day, month, and year.")

#func-ex(
  raw(
"#let date-str = format-date(5, 3, 2024)
#date-str",
    lang: "typ",
    block: true,
  ),
  res: [
    #let date-str = format-date(5, 3, 2024)
    #date-str
  ],
)

#func-params(
  "format-date",
  params: (
    "day": (
      desc: "The day of the month.",
      types: "int",
      default: none,
    ),
    "month": (
      desc: "The month of the year.",
      types: "int",
      default: none,
    ),
    "year": (
      desc: "The year.",
      types: "int",
      default: none,
    ),
  ),
)

#divider()

#func-def("page-config", "Configures page settings (e.g., sidebar, table of contents) using metadata.")

#func-params(
  "page-config",
  params: (
    "sidebar": (
      desc: "Whether to enable the sidebar.",
      types: "bool",
      default: true,
    ),
    "toc": (
      desc: "Whether to enable the table of contents.",
      types: "bool",
      default: true,
    ),
    "toc-min-level": (
      desc: "Minimum heading level to include in the table of contents.",
      types: "int",
      default: 1,
    ),
    "toc-max-level": (
      desc: "Maximum heading level to include in the table of contents.",
      types: "int",
      default: 4,
    ),
    "sidebar-bg": (
      desc: "Background color for the sidebar.",
      types: ("color", "none"),
      default: none,
    ),
    "sidebar-text-color": (
      desc: "Text color for the sidebar.",
      types: ("color", "none"),
      default: none,
    ),
    "sidebar-active-color": (
      desc: "Active link color for the sidebar.",
      types: ("color", "none"),
      default: none,
    ),
    "sidebar-font": (
      desc: "Font for the sidebar.",
      types: ("str", "none"),
      default: none,
    ),
    "sidebar-font-size": (
      desc: "Font size for the sidebar.",
      types: ("length", "none"),
      default: none,
    ),
    "sidebar-font-weight": (
      desc: "Font weight for the sidebar.",
      types: ("str", "none"),
      default: none,
    ),
    "sidebar-margin-x": (
      desc: "Horizontal margin for the sidebar.",
      types: ("length", "none"),
      default: none,
    ),
    "sidebar-margin-y": (
      desc: "Vertical margin for the sidebar.",
      types: ("length", "none"),
      default: none,
    ),
    "toc-bg": (
      desc: "Background color for the table of contents.",
      types: ("color", "none"),
      default: none,
    ),
    "toc-text-color": (
      desc: "Text color for the table of contents.",
      types: ("color", "none"),
      default: none,
    ),
    "toc-font": (
      desc: "Font for the table of contents.",
      types: ("str", "none"),
      default: none,
    ),
    "toc-font-size": (
      desc: "Font size for the table of contents.",
      types: ("length", "none"),
      default: none,
    ),
    "toc-font-weight": (
      desc: "Font weight for the table of contents.",
      types: ("str", "none"),
      default: none,
    ),
    "toc-margin-x": (
      desc: "Horizontal margin for the table of contents.",
      types: ("length", "none"),
      default: none,
    ),
    "toc-margin-y": (
      desc: "Vertical margin for the table of contents.",
      types: ("length", "none"),
      default: none,
    ),
  ),
)

#divider()

#func-def("page-title", "Sets the title of the current page using metadata.")

#func-params(
  "page-title",
  params: (
    "title": (
      desc: "The title to set for the page.",
      types: "str",
      default: none,
    )
  ),
)

#divider()

#func-def("reading-time", "Estimates the reading time for the given content. Shows minutes for 60 minutes or less. Converts to hours and rounds to the nearest hour for over 60 minutes.")

#func-ex(
  raw(
"#let time = (lorem(500))
Reading time: #time

#let long-time = (lorem(50000))
Reading time: #long-time",
    lang: "typ",
    block: true,
  ),
  res: [
    #let time = reading-time(lorem(500))
    Reading time: #time

    #let long-time = reading-time(lorem(50000))
    Reading time: #long-time
  ],
)

#func-params(
  "reading-time",
  params: (
    "title": (
      desc: "The content to estimate reading time for.",
      types: ("str", "content"),
      default: none,
    ),
    "words-per-minute": (
      desc: "The average words per minute reading speed.",
      types: "int",
      default: 200,
    )
  ),
)

#divider()

#func-def("site-link", "Creates a link with optional same-tab behavior. Generates a custom link the is processed by the Typst SSG package that opens a link in the same tab (if specified).")

#func-ex(
  raw(
    "#site-link(\"/about\", \"About Page\", same-tab: true)",
    lang: "typ",
    block: true,
  ),
  res: [
    #site-link("/about", "About Page", same-tab: true)
  ],
)

#func-params(
  "site-link",
  params: (
    "dest": (
      desc: "The destination URL or path relative to the base URL (if set).",
      types: "str",
      default: none,
    ),
    "..body-args": (
      desc: "The body content for the link.",
      types: ("str", "content"),
      default: none,
    ),
    "same-tab": (
      desc: "Whether to open the link in the same tab.",
      types: "bool",
      default: false,
    )
  ),
)

#alert("Note: this function will create an invalid link in normal PDFs using this function. Typst SSG must be used to process the link correctly.")

#divider()

#func-def("set-base", "Sets the base URL for site links.")

#func-ex(
  raw(
    "#set-base(\"http://localhost:3000\")",
    lang: "typ",
    block: true,
  ),
)

#func-params(
  "set-base",
  params: (
    "url": (
      desc: "The base URL to set.",
      types: "str",
      default: none,
    )
  ),
)

= More Documentation

- #link("https://github.com/k0src/Typst-SSG")[Main Typst SSG Repository]
- #link("https://github.com/k0src/Typst-SSG-Package")[Typst SSG npm Package Repository]
- #link("https://github.com/k0src/Typst-SSG-Util-Package")[Typst SSG Package Repository]