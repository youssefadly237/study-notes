// Template for creating nicely formatted study notes
#import "utils.typ": *

/// Main template function for study notes
///
/// This template provides a professional layout for academic notes with:
/// - Customizable cover page
/// - Table of contents
/// - Breadcrumb footer navigation
/// - MCQ support utilities
///
/// Example:
/// ```typst
/// #show: study-notes.with(
///   title: [My Course Notes],
///   author: [My Name],
///   email: [my@email.com],
///   description: [Notes for Course 101],
///   keywords: ("course", "notes"),
///   quote-text: [My inspiring quote here],
///   quote-author: [Someone Famous],
/// )
///
/// = Introduction
/// My content here...
/// ```
///
/// - title (content): Document title (shown on cover page)
/// - author (content): Author name(s)
/// - email (content): Author email for the cover page link. Default: `none`
/// - description (content): Document description for metadata
/// - keywords (array): Array of keyword strings for metadata. Default: `()`
/// - date (datetime): Document date (defaults to today)
/// - paper (str): Paper size (default: "a4")
/// - flipped (bool): Whether to use landscape orientation (default: false)
/// - quote-text (content): Quote text for closing page. Default: `[]`
/// - quote-author (content): Quote attribution. Default: `[]`
/// - show-toc (bool): Whether to show table of contents. Default: `true`
/// - toc-depth (int): Depth of table of contents. Default: `2`
/// - content (content): The main document content
/// -> content
#let study-notes(
  title: [],
  author: [],
  email: none,
  description: [],
  keywords: (),
  date: datetime.today(),
  paper: "a4",
  flipped: false,
  quote-text: [],
  quote-author: [],
  show-toc: true,
  toc-depth: 2,
  content,
) = {
  // Document metadata
  set document(
    title: to-string(title),
    author: to-string(author),
    date: date,
    keywords: keywords,
  )

  // Page setup
  set page(
    paper: paper,
    flipped: flipped,
    numbering: "i",
    footer: context {
      // Main footer logic
      let current-page = here().page()

      // Skip footer for Cover and Closing pages
      if (
        has-label-on-page(<Cover>, current-page)
          or has-label-on-page(<Closing>, current-page)
          or has-label-on-page(<BlankPage>, current-page)
      ) {
        return none
      }

      // Build breadcrumb: level1 | level2 (with level2 truncated)
      let level1 = get-footer-heading(1)
      let level2 = get-footer-heading(2)

      // Only use level2 if it actually belongs to level1
      let breadcrumb = if level1 != none and level2 != none and is-child-of(level1, level2) {
        [#level1.body | #truncate-text(level2.body)]
      } else if level1 != none {
        level1.body
      } else if level2 != none {
        truncate-text(level2.body)
      } else {
        []
      }

      // Format and return footer
      format-footer(breadcrumb, counter(page).display())
    },
  )

  // Heading setup
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

  // List & enum setup
  set list(indent: 1em)
  set enum(indent: 1em)

  // Paragraph setup
  set par(leading: 0.9em)

  // Table setup
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

  // Quote setup
  set quote(block: true)
  show quote: set align(center)
  show quote: set pad(x: 5em)

  // Hide the cover heading from display
  show heading.where(label: <Cover>): none

  // Cover page
  hidden-heading(<Cover>)[Cover]
  align(center + horizon)[
    #text(title, size: 20pt, weight: "bold")
    #v(1em)
    #if email != none {
      link("mailto:" + to-string(email))[
        #text(author, size: 12pt, weight: "bold", style: "italic")
      ]
    } else {
      text(author, size: 12pt, weight: "bold", style: "italic")
    }
    #v(0.5em)
    #text(size: 11pt)[
      #date.display("[month repr:long] [day], [year]")
    ]
    #v(15em)
  ]

  pagebreak()

  // Table of Contents
  if show-toc {
    outline(title: "Table of Contents", depth: toc-depth)
    pagebreak()

    [#align(center + horizon)[
      This page is left blank intentionally.
    ] <BlankPage>]

    // Reset page count for content
    pagebreak()
  } else {
    blank-page()
    pagebreak()
  }

  counter(page).update(1)
  set page(paper: paper, flipped: flipped, numbering: "1")

  // Main content
  content

  // Closing page (only if quote provided)
  if quote-text != [] {
    pagebreak()
    hidden-heading(<Closing>)[Closing]
    align(center + horizon)[
      #quote(attribution: quote-author)[#quote-text]
    ]
  }
}
