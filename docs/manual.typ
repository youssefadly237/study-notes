// study-notes package manual

#set document(title: "study-notes Manual", author: "J. Adly")
#set page(paper: "a4", numbering: "1", margin: (x: 2.5cm, y: 2.5cm))
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.1.")
#set par(justify: true)

#show link: underline
#show raw.where(block: true): set block(fill: luma(245), inset: 1em, radius: 4pt, width: 100%)
#show raw.where(block: false): set box(fill: luma(245), inset: (x: 3pt), outset: (y: 3pt), radius: 2pt)

// Title
#align(center)[
  #text(size: 24pt, weight: "bold")[study-notes]
  #v(0.3em)
  #text(size: 14pt, fill: gray)[Package Manual - v0.1.0]
  #v(2em)
]

// Table of Contents
#outline(title: "Contents", indent: 1.5em, depth: 2)
#pagebreak()

// ============================================================
= Introduction

The `study-notes` package provides a Typst template for creating nicely formatted academic study notes. It includes:

- A customisable cover page with optional email link
- Automatic table of contents
- Breadcrumb footer navigation showing the current section
- Alternating odd/even page footer layout
- MCQ (multiple choice question) utilities
- Auto-numbered lecture headings per subject
- Side-by-side matched-height grid layout

= Quick Start

Import the package and apply the show rule:

```typst
#import "@preview/study-notes:0.1.0": study-notes

#show: study-notes.with(
  title: "My Course Notes",
  author: "Your Name",
  email: "your.email@example.com",
  description: "Notes for Course 101",
  keywords: ("course", "notes"),
  quote-text: [An inspiring quote.],
  quote-author: [Someone Famous],
)

= Introduction
Your content here...
```

This produces a document with a cover page, table of contents, your content with breadcrumb footers, and a closing quote page.

= Template Parameters <params>

The `study-notes` function accepts the following named parameters:

#table(
  columns: (auto, auto, auto, 1fr),
  table.header([*Parameter*], [*Type*], [*Default*], [*Description*]),
  [`title`], [`content`], [`[]`], [Document title displayed on the cover page.],
  [`author`], [`content`], [`[]`], [Author name(s) shown on the cover page.],
  [`email`], [`content`], [`none`], [Author email. When provided, the author name becomes a `mailto:` link.],
  [`description`], [`content`], [`[]`], [Document description for PDF metadata.],
  [`keywords`], [`array`], [`()`], [Array of keyword strings for PDF metadata.],
  [`date`], [`datetime`], [`datetime.today()`], [Document date shown on the cover.],
  [`paper`], [`str`], [`"a4"`], [Paper size (any Typst paper size string).],
  [`flipped`], [`bool`], [`false`], [Whether to use landscape orientation.],
  [`quote-text`], [`content`], [`[]`], [Quote text for the closing page. No closing page is generated if empty.],
  [`quote-author`], [`content`], [`[]`], [Attribution for the closing page quote.],
  [`show-toc`], [`bool`], [`true`], [Whether to show a table of contents.],
  [`toc-depth`], [`int`], [`2`], [Maximum heading depth shown in the table of contents.],
)

= Document Structure

When you apply the template, the generated document has this structure:

+ *Cover page* - title, author (optionally linked to email), and date. Page numbering uses roman numerals (`i, ii, ...`).
+ *Table of contents* - (if `show-toc` is `true`) followed by a blank page.
+ *Main content* - page counter resets to `1` with arabic numerals. Footers show a breadcrumb of the current level-1 and level-2 headings.
+ *Closing page* - (if `quote-text` is not empty) a centred quote with attribution.

== Heading Numbering

Level-1 and level-2 headings are not numbered in the body but appear in the table of contents and bookmarks. Sub-headings from level 3 onward are numbered as `1.1.1.` etc.

Level-1 headings are centred with extra vertical spacing.

== Footer Breadcrumbs

The footer displays a breadcrumb trail of the form:

#align(center)[_Section Title | Subsection Title_ #h(1fr) _page number_]

On even pages, the layout is mirrored. The footer is suppressed on the cover, closing, and blank pages.

= Utility Functions

All utility functions are exported from the package entry point and can be imported directly:

```typst
#import "@preview/study-notes:0.1.0": mcq, mcqs, mcq-answers, lec, matched-height-grid
```

== MCQ Functions <mcq>

=== `mcq(question, answers)`

Creates a single multiple choice question with lettered answer choices (`a)`, `b)`, etc.).

#table(
  columns: (auto, auto, 1fr),
  table.header([*Parameter*], [*Type*], [*Description*]),
  [`question`], [`content`], [The question text.],
  [`answers`], [`array`], [Array of answer choice contents.],
)

```typst
#mcq([What is 2+2?], ([2], [3], [4], [5]))
```

=== `mcqs(questions, title: [], start: 1)`

Creates multiple numbered MCQs in sequence.

#table(
  columns: (auto, auto, auto, 1fr),
  table.header([*Parameter*], [*Type*], [*Default*], [*Description*]),
  [`questions`], [`array`], [-], [Array of `(question, answers)` pairs.],
  [`title`], [`content`], [`[]`], [Optional title displayed above the questions.],
  [`start`], [`int`], [`1`], [Starting number for question numbering.],
)

```typst
#mcqs((
  ([What is 2+2?], ([2], [3], [4], [5])),
  ([What is 3+3?], ([5], [6], [7], [8])),
), title: [*Section A*], start: 1)
```

=== `mcq-answers(answers, columns: 3, start: 1, title: [])`

Displays answer keys in a multi-column grid layout.

#table(
  columns: (auto, auto, auto, 1fr),
  table.header([*Parameter*], [*Type*], [*Default*], [*Description*]),
  [`answers`], [`array`], [-], [Array of answer contents.],
  [`columns`], [`int`], [`3`], [Number of grid columns.],
  [`start`], [`int`], [`1`], [Starting number for answer numbering.],
  [`title`], [`content`], [`[]`], [Optional title above the answers.],
)

```typst
#mcq-answers(([c], [b], [a], [d]), columns: 2, title: [*Answers:*])
```

== Lecture Headings <lec>

=== `lec(subject, title)`

Creates an auto-numbered level-2 heading prefixed with "Lec. N". Each subject maintains its own independent counter.

#table(
  columns: (auto, auto, 1fr),
  table.header([*Parameter*], [*Type*], [*Description*]),
  [`subject`], [`str`], [Subject name used to track the counter (e.g., `"Anatomy"`).],
  [`title`], [`content`], [The lecture title.],
)

```typst
= Anatomy
#lec("Anatomy", "Oral Cavity and Pharynx")
// Renders: "Lec. 1  Oral Cavity and Pharynx"

#lec("Anatomy", "Esophagus and Stomach")
// Renders: "Lec. 2  Esophagus and Stomach"

= Histology
#lec("Histology", "Epithelial Tissue")
// Renders: "Lec. 1  Epithelial Tissue" (separate counter)
```

== Layout Utilities <layout>

=== `matched-height-grid(left, right, columns: (2fr, 1fr))`

Places two pieces of content side by side, with the right column's height matched to the left column.

#table(
  columns: (auto, auto, auto, 1fr),
  table.header([*Parameter*], [*Type*], [*Default*], [*Description*]),
  [`left`], [`content`], [-], [Left column content.],
  [`right`], [`content`], [-], [Right column content (vertically centred, height matched to left)],
  [`columns`], [`array`], [`(2fr, 1fr)`], [Column width fractions.],
)

```typst
#matched-height-grid(
  [Some longer text content that spans
   multiple lines on the left side.],
  rect(fill: blue.lighten(80%), [Figure]),
  columns: (2fr, 1fr),
)
```

= Internal Utilities

These functions are exported but are primarily used internally by the template. They may be useful for advanced customisation.

#table(
  columns: (auto, 1fr),
  table.header([*Function*], [*Description*]),
  [`to-string(content)`], [Recursively converts content to a plain string.],
  [`hidden-heading(label, body)`],
  [Creates a heading that is hidden from display but present in the document structure.],

  [`blank-page()`], [Inserts a centred "This page is left blank intentionally." with a `<BlankPage>` label.],
  [`has-label-on-page(label, page)`], [Checks whether a label exists on a given page number.],
  [`get-last-heading(level)`], [Returns the last heading of a given level before the current position.],
  [`is-child-of(h1, h2)`], [Checks if `h2` appears on or after `h1`'s page.],
  [`truncate-text(content, max-len: 50)`], [Truncates text to `max-len` characters with ellipsis.],
  [`format-footer(left, right)`], [Formats footer with alternating odd/even page layout.],
)

= License

This package is released under the MIT-0 license.
