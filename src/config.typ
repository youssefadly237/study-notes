// imports
#import "utils.typ"

/// Sets up document metadata
#let setup-metadata(title, author, description, keywords: ()) = {
  set document(
    title: title,
    author: author,
    date: datetime.today(),
    keywords: keywords,
  )
}

/// Configures page settings with custom footer
#let setup-page() = {
  set page(
    paper: "a4",
    flipped: false,
    numbering: "i",
    footer: context {
      let current-page = here().page()
      // Skip footer for special pages
      if (
        utils.has-label-on-page(<Cover>, current-page)
          or utils.has-label-on-page(<Closing>, current-page)
          or utils.has-label-on-page(<BlankPage>, current-page)
      ) {
        return none
      }
      // Build breadcrumb
      let level1 = utils.get-last-heading(1)
      let level2 = utils.get-last-heading(2)
      let breadcrumb = if level1 != none and level2 != none and utils.is-child-of(level1, level2) {
        [#level1.body | #utils.truncate-text(level2.body)]
      } else if level1 != none {
        level1.body
      } else if level2 != none {
        utils.truncate-text(level2.body)
      } else {
        []
      }
      utils.format-footer(breadcrumb, counter(page).display())
    },
  )
}

/// Configures heading styles and numbering
#let setup-headings() = {
  set heading(bookmarked: true, outlined: true, numbering: (..nums) => {
    let levels = nums.pos()
    if levels.len() >= 3 {
      let local-levels = levels.slice(2)
      numbering("1.1.1.", ..local-levels)
    }
  })
  show heading.where(level: 1): it => {
    set align(center)
    v(0.5em)
    it
    v(0.3em)
  }
  show heading.where(label: <Cover>): none
}

/// Configures text elements (lists, paragraphs, quotes)
#let setup-text-elements() = {
  set list(indent: 1em)
  set enum(indent: 1em)
  set par(leading: 0.9em)
  set quote(block: true)
  show quote: set align(center)
  show quote: set pad(x: 5em)
}

/// Configures table styling
#let setup-tables() = {
  set table(
    stroke: (x, y) => (
      top: if y == 0 { none } else { gray },
      left: if x == 0 { none } else { gray },
    ),
    fill: (x, y) => if (y - 2 * calc.quo(y, 2) == 0) {
      rgb("F5F5F5")
    },
    inset: (right: 1.5em, left: 1.5em, top: 1em, bottom: 1em),
    align: horizon + left,
  )
}

/// Creates the cover page
#let make-cover(title, author, email: none) = {
  utils.hidden-heading(<Cover>)[Cover]
  align(center + horizon)[
    #text(title, size: 20pt, weight: "bold")
    #v(1em)
    #if email != none {
      link("mailto:" + str(email))[
        #text(author, size: 12pt, weight: "bold", style: "italic")
      ]
    } else {
      text(author, size: 12pt, weight: "bold", style: "italic")
    }
    #v(0.5em)
    #let today = datetime.today()
    #text(size: 11pt)[
      #today.display("[month repr:long] [day], [year]")
    ]
    #v(15em)
  ]
  pagebreak()
}

/// Creates table of contents with blank page
#let make-toc() = {
  set page()
  pagebreak()
  outline(title: "Table of Contents", depth: 2)
  pagebreak()
  utils.blank-page()
  pagebreak()
}

/// Resets page numbering for main content
#let start-main-content() = {
  counter(page).update(1)
  set page(paper: "a4", flipped: false, numbering: "1")
}

/// Main document configuration function
///
/// - title (content): Document title
/// - author (content): Document author
/// - description (str): Document description
/// - doc (content): The document content
/// -> content
#let conf(
  title: "Untitled",
  author: "Anonymous",
  description: "",
  doc,
) = {
  setup-metadata(title, author, description)
  setup-page()
  setup-headings()
  setup-text-elements()
  setup-tables()

  make-cover(title, author)
  make-toc()
  start-main-content()

  doc
}


