#import "@preview/tidy:0.4.3": *
#import "../lib.typ"

#set page(
  paper: "us-letter",
  margin: (top: 6em, right: 6em, bottom: 6em, left: 6em),
)

#set text(
  font: ("PT Sans", "Open Sans", "Arial"),
  size: 11pt,
  fill: rgb("#1a1a1a"),
)

#set heading(numbering: none)

#show link: it => underline(text(fill: rgb("#2980b9"))[#it])

#show raw.where(block: true): it => block(
  width: 100%,
  inset: 1em,
  radius: 0.2em,
  fill: rgb("#f8f8f8"),
  text(size: 1em, fill: rgb("#333"))[#it],
)

#let docs = parse-module(
  read("../lib.typ"),
  name: "Typst SSG Util Library",
  scope: (lib: lib),
  preamble: "#import lib: *\n"
)

#show-module(docs, show-outline: false)
