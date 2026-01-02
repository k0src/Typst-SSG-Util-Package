#import "@preview/fontawesome:0.6.0": *

/// Base URL state for site links.
#let base-url = state("site-link-base", "")

/// Sets the base URL for site links.
#let set-base(
  /// The base URL to set. -> str
  url,
) = {
  base-url.update(url)
}

/// Creates a link with optional same-tab behavior.
///
/// *Example:*
///
/// ```typ
/// #site-link("/blog", same-tab: true)[Blog]
/// ```
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
  let base = base-url.get()

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

  if minutes == 1 {
    return "1 min read"
  } else {
    return str(minutes) + " min read"
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
#let divider(
  /// Space before the divider. -> length
  space-before: 1em,
  /// Space after the divider. -> length
  space-after: 1em,
) = {
  v(space-before)
  line(length: 100%, stroke: 0.5pt + rgb("#ddd"))
  v(space-after)
}


/// Renders a styled code block with a copy button.
///
/// *Example:*
///
/// #raw(
///   "
///     #code-block(
///       ```js
///       function greet(name) {
///         console.log(`Hello, ${name}!`);
///         return true;
///       }
///
///       greet(\"World\");
///       ```
///     )
///   ",
///   lang: "typ",
///   block: true
/// )
///
#let code-block(
  /// The code content to display. -> str|content
  code,
  /// Custom styles for the code block. -> dictionary
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
  )
  
  let s = if styles == none {
    default-styles
  } else {
    default-styles + styles
  }
  
  block(
    width: 100%,
    inset: 1em,
    radius: s.radius,
    fill: s.fill,
    stroke: s.stroke,
    breakable: false,
    {
      if s.text-color != none {
        text(fill: s.text-color)[#code <code-block>]
      } else {
        [#code <code-block>]
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

/// Configures page settings (e.g., sidebar, table of contents)
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
