// Page Setup
#set page(
  margin: (
    x: 3cm,
    y: 3cm
  )
)
#set text(
  font: "Libertinus Serif",
  size: 11pt,
)

#set heading(
  numbering: "1."

)

// Title Page
#let author ="(Brandon Tang)"
#let title = "Automatic Abstraction for
Relational Symbolic Trajectory Evaluation"

#align(center)[
  #block(text(weight: 600, 1.75em, title))
  #v(1em, weak: true)
  #text(weight: 500, 1.4em, author)
  #v(1em, weak: true)
  #text(weight: 500, 1.1em, "Computer Science (Part B)")

  #v(1em, weak: true)
  #text(weight: 500, 1.1em, "Trinity 2025")

  #v(1em, weak: true)
  #text(weight: 500, 1.1em, "Word Count: ?")

]



#pagebreak()

// Abstract
#set par(
  justify: true,
  leading: 1em,
)
#set page(
  numbering: "1"
)
#counter(page).update(1)

= Abstract

#pagebreak()

// Content Page

#outline(
  indent: auto
)

#pagebreak()



= Introduction

== Background
== Contribution
== Relation to Companion Project

= References
