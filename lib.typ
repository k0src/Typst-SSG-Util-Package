#import "@preview/fontawesome:0.6.0": *

/// Base URL for site links.
#let _base-url = state("site-link-base", "")

/// Sets the base URL for site links.
///
/// - url (str): The base URL to set.
#let set-base(url) = {
  let clean-url = if url.ends-with("/") {
    url.slice(0, -1)
  } else {
    url
  }
  _base-url.update(clean-url)
}

/// Creates a link with optional same-tab behavior.
///
/// - dest (str): The destination URL.
/// - body-args (str, content): The body content for the link.
/// - same-tab (bool): Whether to open the link in the same tab.
#let site-link(dest, ..body-args, same-tab: false) = context {
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
/// - content (str, content): The content to estimate reading time for.
/// - words-per-minute (int): The average words per minute reading speed.
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

/// Formats a date given day, month, and year.
///
/// - day (int): The day of the month.
/// - month (int): The month of the year.
/// - year (int): The year.
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

/// Renders a horizontal divider with spacing.
///
/// - space-before (length): Space before the divider.
/// - space-after (length): Space after the divider.
/// - stroke (auto, color, gradient): Divider stroke color and width.
#let divider(
  space-before: 0.5em,
  space-after: 0.5em,
  stroke: 0.5pt + rgb("#ddd"),
) = {
  v(space-before)
  line(length: 100%, stroke: stroke)
  v(space-after)
}

/// Renders inline code with styling.
///
/// - code (str, content): The code content to display.
/// - lang (str): The language for syntax highlighting.
/// - styles (dictionary): Custom styles for the inline code.
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
      text(fill: s.text-color)[#raw(code, lang: lang) <tssg-code>]
    } else {
      [#raw(code, lang: lang) <tssg-code>]
    },
  )
}

/// Renders a styled code block with a copy button.
///
/// - code (str, content): The code content to display.
/// - styles (dictionary): Custom styles for the code block.
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
///
/// - title (str): The title to set for the page.
#let page-title(
  title,
) = {
  metadata((
    type: "tssg-page-title",
    title: title,
  ))
}

/// Configures page settings (e.g., sidebar, table of contents).
///
/// - sidebar (bool): Whether to enable the sidebar.
/// - toc (bool): Whether to enable the table of contents.
/// - toc-min-level (int): Minimum heading level to include in the table of contents.
/// - toc-max-level (int): Maximum heading level to include in the table of contents.
/// - sidebar-bg (color):  Background color for the sidebar.
/// - sidebar-text-color (color): Text color for the sidebar.
/// - sidebar-active-color (color): Active link color for the sidebar.
/// - sidebar-font (str): Font for the sidebar.
/// - sidebar-font-size (length): Font size for the sidebar.
/// - sidebar-font-weight (str): Font weight for the sidebar.
/// - sidebar-margin-x (length): Horizontal margin for the sidebar.
/// - sidebar-margin-y (length): Vertical margin for the sidebar.
/// - toc-bg (color): Background color for the table of contents.
/// - toc-text-color (color): Text color for the table of contents.
/// - toc-font (str): Font for the table of contents.
/// - toc-font-size (length): Font size for the table of contents.
/// - toc-font-weight (str): Font weight for the table of contents.
/// - toc-margin-x (length): Horizontal margin for the table of contents.
/// - toc-margin-y (length): Vertical margin for the table of contents.
#let page-config(
  sidebar: true,
  toc: true,
  toc-min-level: 1,
  toc-max-level: 4,
  sidebar-bg: none,
  sidebar-text-color: none,
  sidebar-active-color: none,
  sidebar-font: none,
  sidebar-font-size: none,
  sidebar-font-weight: none,
  sidebar-margin-x: none,
  sidebar-margin-y: none,
  toc-bg: none,
  toc-text-color: none,
  toc-font: none,
  toc-font-size: none,
  toc-font-weight: none,
  toc-margin-x: none,
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
