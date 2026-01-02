#import "@preview/fontawesome:0.6.0": *

#let _base-url = state("site-link-base", "")

/// Sets the base URL for site links.
/// 
/// *Example:*
/// 
/// ```typ
/// #set-base("http://localhost:3000")
/// ```
#let set-base(
    /// The base URL to set. -> str
    url
  ) = {
  let clean-url = if url.ends-with("/") {
    url.slice(0, -1)
  } else {
    url
  }
  _base-url.update(clean-url)
}

/// Creates a link with optional same-tab behavior.
///
/// *Example:*
/// 
/// #let ex-cb(code) = {
///   block(
///     width: 100%,
///     inset: 1em,
///     radius: 0.2em,
///     fill: rgb("#f8f8f8"),
///     stroke: 0.5pt + rgb("#c8c8c8"),
///     breakable: false,
///     { code },
///   )
/// }
///
/// #ex-cb(raw("#site-link(\"/blog\", same-tab: true)[Blog]",
///   lang: "typ",
///   block: true
/// ))
///
/// -> content
#let site-link(
    /// The destination URL. -> str
    dest,
    /// The body content for the link. -> content
    ..body-args,
    /// Whether to open the link in the same tab. -> bool
    same-tab: false,
  ) = context {
  let base = _base-url.get()

  let full-dest = if base != "" and type(dest) == str {
    base + dest
  } else {
    dest
  }

  let actual-dest = if same-tab and type(full-dest) == str {
    "tssg:sametab:" + full-dest
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

/// Estimates the reading time for the given content.
///
/// *Example:*
///
/// ```example
/// #let time = reading-time(lorem(500))
/// #time
/// ```
#let reading-time(
    /// The content to estimate reading time for. -> content
    content,
    /// The average words per minute reading speed. -> int
    words-per-minute: 200,
  ) = {
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

/// Formats a date given day, month, and year.
///
/// *Example:*
///
/// ```example
/// #let date-str = format-date(5, 3, 2024)
/// #date-str
/// ```
#let format-date(
    /// The day of the month. -> int
    day,
    /// The month of the year. -> int
    month,
    /// The year. -> int
    year,
  ) = {
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

/// Renders a horizontal divider with spacing.
/// 
/// *Example:*
/// 
/// ```example
/// Hello
/// #divider(space-before: 0.2em, space-after: 0.2em)
/// World
/// ```
#let divider(
    /// Space before the divider. -> length
    space-before: 0.5em,
    /// Space after the divider. -> length
    space-after: 0.5em,
    stroke: 0.5pt,
  ) = {
  v(space-before)
  line(length: 100%, stroke: stroke + rgb("#ddd"))
  v(space-after)
}

/// Renders inline code with styling.
/// 
/// *Example:*
/// 
/// ```example
/// Inline #c("code")
/// 
/// Inline code with language: #c("console.log('Hello');", lang: "js")
/// ```
#let c(
    /// The code content to display. -> str|content
    code, 
    /// The language for syntax highlighting. -> str
    lang: "text", 
    /// Custom styles for the inline code. 
    /// 
    /// #let rainbow-map = (
    ///   (rgb("#7cd5ff"), 0%), 
    ///   (rgb("#a6fbca"), 33%),
    ///   (rgb("#fff37c"), 66%), 
    ///   (rgb("#ffa49d"), 100%)
    /// )
    /// 
    /// #let gradient-for-color-types = gradient.linear(angle: 7deg, ..rainbow-map)
    /// #let gradient-for-tiling = gradient.linear(
    ///   angle: -45deg, 
    ///   rgb("#ffd2ec"), 
    ///   rgb("#c6feff")
    /// ).sharp(2).repeat(5)
    /// 
    /// #let default-type-color = rgb("#eff0f3")
    /// 
    /// #let colors = (
    ///   "default": default-type-color,
    ///   "content": rgb("#a6ebe6"),
    ///   "string": rgb("#d1ffe2"),
    ///   "str": rgb("#d1ffe2"),
    ///   "none": rgb("#ffcbc4"),
    ///   "auto": rgb("#ffcbc4"),
    ///   "bool": rgb("#ffedc1"),
    ///   "boolean": rgb("#ffedc1"),
    ///   "integer": rgb("#e7d9ff"),
    ///   "int": rgb("#e7d9ff"),
    ///   "float": rgb("#e7d9ff"),
    ///   "ratio": rgb("#e7d9ff"),
    ///   "length": rgb("#e7d9ff"),
    ///   "angle": rgb("#e7d9ff"),
    ///   "relative length": rgb("#e7d9ff"),
    ///   "relative": rgb("#e7d9ff"),
    ///   "fraction": rgb("#e7d9ff"),
    ///   "symbol": default-type-color,
    ///   "array": default-type-color,
    ///   "dictionary": default-type-color,
    ///   "arguments": default-type-color,
    ///   "selector": default-type-color,
    ///   "module": default-type-color,
    ///   "stroke": default-type-color,
    ///   "function": rgb("#f9dfff"),
    ///   "color": gradient-for-color-types,
    ///   "gradient": gradient-for-color-types,
    ///   "tiling": gradient-for-tiling,
    ///   "signature-func-name": rgb("#4b69c6"),
    /// )
    /// 
    /// #let show-type(type, style-args: (:)) = { 
    ///   h(2pt)
    ///   let clr = style-args.colors.at(
    ///     type, 
    ///     default: style-args.colors.at(
    ///       "default", 
    ///       default: default-type-color)
    ///   )
    ///   box(
    ///     outset: 2pt, 
    ///     fill: clr, 
    ///     radius: 2pt, 
    ///     raw(type, lang: none)
    ///   )
    ///   h(2pt)
    /// }
    /// 
    /// - `fill`: #show-type("color", style-args: (colors: colors)) #show-type("gradient", style-args: (colors: colors))
    ///   - Background fill color
    /// - `inset`: #show-type("dictionary", style-args: (colors: colors))
    ///   - Inner padding with `x`: #show-type("length", style-args: (colors: colors)) and `y`: #show-type("length", style-args: (colors: colors))
    /// - `outset`: #show-type("dictionary", style-args: (colors: colors))
    ///   - Outer spacing with `x`: #show-type("length", style-args: (colors: colors)) and `y`: #show-type("length", style-args: (colors: colors))
    /// - `radius`: #show-type("length", style-args: (colors: colors)) 
    ///   - Corner radius
    /// - `text-color`: #show-type("color", style-args: (colors: colors)) #show-type("gradient", style-args: (colors: colors))
    ///   - Text color for the code
    /// 
    /// -> dictionary
    styles: none
  ) = {
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
      text(fill: s.text-color)[#raw(code, lang: lang) <tssg-code>]
    } else {
      [#raw(code, lang: lang) <tssg-code>]
    },
  )
}

/// Renders a styled code block with a copy button.
///
/// *Example:*
/// 
/// #let ex-cb(code) = {
///   block(
///     width: 100%,
///     inset: 1em,
///     radius: 0.2em,
///     fill: rgb("#f8f8f8"),
///     stroke: 0.5pt + rgb("#c8c8c8"),
///     breakable: false,
///     { code },
///   )
/// }
///
/// #ex-cb(raw(
/// "#code-block(
///   ```js
///   function greet(name) {
///     console.log(`Hello, ${name}!`);
///     return true;
///   }
///
///   greet(\"World\");
///   ```
/// )",
///   lang: "typ",
///   block: true
/// ))
///
#let code-block(
    /// The code content to display. -> str|content
    code,
    /// Custom styles for the code block.
    ///
    /// #let rainbow-map = (
    ///   (rgb("#7cd5ff"), 0%), 
    ///   (rgb("#a6fbca"), 33%),
    ///   (rgb("#fff37c"), 66%), 
    ///   (rgb("#ffa49d"), 100%)
    /// )
    /// 
    /// #let gradient-for-color-types = gradient.linear(angle: 7deg, ..rainbow-map)
    /// #let gradient-for-tiling = gradient.linear(
    ///   angle: -45deg, 
    ///   rgb("#ffd2ec"), 
    ///   rgb("#c6feff")
    /// ).sharp(2).repeat(5)
    /// 
    /// #let default-type-color = rgb("#eff0f3")
    /// 
    /// #let colors = (
    ///   "default": default-type-color,
    ///   "content": rgb("#a6ebe6"),
    ///   "string": rgb("#d1ffe2"),
    ///   "str": rgb("#d1ffe2"),
    ///   "none": rgb("#ffcbc4"),
    ///   "auto": rgb("#ffcbc4"),
    ///   "bool": rgb("#ffedc1"),
    ///   "boolean": rgb("#ffedc1"),
    ///   "integer": rgb("#e7d9ff"),
    ///   "int": rgb("#e7d9ff"),
    ///   "float": rgb("#e7d9ff"),
    ///   "ratio": rgb("#e7d9ff"),
    ///   "length": rgb("#e7d9ff"),
    ///   "angle": rgb("#e7d9ff"),
    ///   "relative length": rgb("#e7d9ff"),
    ///   "relative": rgb("#e7d9ff"),
    ///   "fraction": rgb("#e7d9ff"),
    ///   "symbol": default-type-color,
    ///   "array": default-type-color,
    ///   "dictionary": default-type-color,
    ///   "arguments": default-type-color,
    ///   "selector": default-type-color,
    ///   "module": default-type-color,
    ///   "stroke": default-type-color,
    ///   "function": rgb("#f9dfff"),
    ///   "color": gradient-for-color-types,
    ///   "gradient": gradient-for-color-types,
    ///   "tiling": gradient-for-tiling,
    ///   "signature-func-name": rgb("#4b69c6"),
    /// )
    /// 
    /// #let show-type(type, style-args: (:)) = { 
    ///   h(2pt)
    ///   let clr = style-args.colors.at(
    ///     type, 
    ///     default: style-args.colors.at(
    ///       "default", 
    ///       default: default-type-color)
    ///   )
    ///   box(
    ///     outset: 2pt, 
    ///     fill: clr, 
    ///     radius: 2pt, 
    ///     raw(type, lang: none)
    ///   )
    ///   h(2pt)
    /// }
    /// 
    /// - `fill`: #show-type("color", style-args: (colors: colors)) #show-type("gradient", style-args: (colors: colors))
    ///   - Background fill color
    /// - `stroke`: #show-type("auto", style-args: (colors: colors)) #show-type("length", style-args: (colors: colors)) #show-type("color", style-args: (colors: colors)) #show-type("gradient", style-args: (colors: colors))
    ///   - Border stroke color and width
    /// - `radius`: #show-type("length", style-args: (colors: colors))
    ///   - Corner radius
    /// - `icon-color`: #show-type("color", style-args: (colors: colors)) #show-type("gradient", style-args: (colors: colors))
    ///   - Color for the copy icon
    /// - `text-color`: #show-type("color", style-args: (colors: colors)) #show-type("gradient", style-args: (colors: colors))
    ///   - Text color for the code
    /// 
    /// -> dictionary
    styles: none,
  ) = {
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
        text(fill: s.text-color)[#code <tssg-code>]
      } else {
        [#code <tssg-code>]
      }
      place(
        top + right,
        link(
          "tssg:copy:" + code-text,
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

/// Sets the title of the current page using metadata.
#let page-title(
    /// The title to set for the page. -> str
    title
  ) = {
  metadata((
    type: "tssg-page-title",
    title: title,
  ))
}

/// Configures page settings (e.g., sidebar, table of contents).
#let page-config(
    /// Whether to enable the sidebar. -> bool
    sidebar: true,
    /// Whether to enable the table of contents. -> bool
    toc: true,
    /// Minimum heading level to include in the table of contents. -> int
    toc-min-level: 1,
    /// Maximum heading level to include in the table of contents. -> int
    toc-max-level: 4,
    /// Background color for the sidebar. -> color|none
    sidebar-bg: none,
    /// Text color for the sidebar. -> color|none
    sidebar-text-color: none,
    /// Active link color for the sidebar. -> color|none
    sidebar-active-color: none,
    /// Font for the sidebar. -> str|none
    sidebar-font: none,
    /// Font size for the sidebar. -> length|none
    sidebar-font-size: none,
    /// Font weight for the sidebar. -> str|none
    sidebar-font-weight: none,
    /// Horizontal margin for the sidebar. -> length|none
    sidebar-margin-x: none,
    /// Vertical margin for the sidebar. -> length|none
    sidebar-margin-y: none,
    /// Background color for the table of contents. -> color|none
    toc-bg: none,
    /// Text color for the table of contents. -> color|none
    toc-text-color: none,
    /// Font for the table of contents. -> str|none
    toc-font: none,
    /// Font size for the table of contents. -> length|none
    toc-font-size: none,
    /// Font weight for the table of contents. -> str|none
    toc-font-weight: none,
    /// Horizontal margin for the table of contents. -> length|none
    toc-margin-x: none,
    /// Vertical margin for the table of contents. -> length|none
    toc-margin-y: none,
  ) = {
  metadata((
    type: "tssg-page-config",
    sidebar: sidebar,
    toc: toc,
    toc-min-level: toc-min-level,
    toc-max-level: toc-max-level,
    sidebar-bg: sidebar-bg,
    sidebar-text-color: sidebar-text-color,
    sidebar-active-color: sidebar-active-color,
    sidebar-font: sidebar-font,
    sidebar-font-size: sidebar-font-size,
    sidebar-font-weight: sidebar-font-weight,
    sidebar-margin-x: sidebar-margin-x,
    sidebar-margin-y: sidebar-margin-y,
    toc-bg: toc-bg,
    toc-text-color: toc-text-color,
    toc-font: toc-font,
    toc-font-size: toc-font-size,
    toc-font-weight: toc-font-weight,
    toc-margin-x: toc-margin-x,
    toc-margin-y: toc-margin-y,
  ))
}
