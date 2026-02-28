/*
Utils
*/

/// Creates a heading that won't be displayed
///
/// Example: `#hidden-heading(<Closing>)[Closing]`
///
/// - label-name (label): The label to attach to the heading
/// - body (content): The heading text
/// -> content
#let hidden-heading(label-name, body) = {
  show heading.where(label: label-name): none
  [#heading(body)#label-name]
}

/// Creates a centered blank page
///
/// Example: `#blank-page()`
#let blank-page() = {
  [#align(center + horizon)[
    This page is left blank intentionally.
  ] <BlankPage>]
}

/// Recursively converts content to a plain string
///
/// Example: `to-string([*Bold* text]) // "Bold text"`
///
/// - content (content): The content to convert to string
/// -> str
#let to-string(content) = {
  if type(content) == str {
    content
  } else if content.has("text") {
    if type(content.text) == str {
      content.text
    } else {
      to-string(content.text)
    }
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

/// Checks if a specific label exists on a given page
///
/// Example: `has-label-on-page(<intro>, 1) // true if <intro> is on page 1`
///
/// - label (label): The label to search for
/// - current-page (int): The page number to check
/// -> bool
#let has-label-on-page(label, current-page) = {
  query(selector(label)).filter(h => h.location().page() == current-page).len() > 0
}

/// Gets the last heading of a specific level before the current position
///
/// Example: `get-last-heading(1) // Returns last level-1 heading`
///
/// - level (int): The heading level to search for (1, 2, 3, etc.)
/// -> content or none
#let get-last-heading(level) = {
  let headings = query(selector(heading.where(level: level)).before(here()))
  if headings.len() > 0 {
    headings.last()
  } else {
    none
  }
}

/// Gets the heading to show in the footer for a given level.
/// Prefers the first heading that starts on the current page (so multi-lecture
/// pages show the lecture the page opened with). Falls back to the last heading
/// that started before the current page if none appear on it.
///
/// - level (int): The heading level to search for (1, 2, 3, etc.)
/// -> content or none
#let get-footer-heading(level) = {
  let current-page = here().page()
  let on-page = query(heading.where(level: level)).filter(
    h => h.location().page() == current-page
  )
  if on-page.len() > 0 {
    on-page.first()
  } else {
    let before = query(selector(heading.where(level: level)).before(here()))
    if before.len() > 0 { before.last() } else { none }
  }
}

/// Checks if heading2 appears on or after heading1's page
///
/// Example: `is-child-of(h1, h2) // true if h2 comes after h1`
///
/// - h1 (content or none): The parent heading
/// - h2 (content or none): The potential child heading
/// -> bool
#let is-child-of(h1, h2) = {
  if h1 == none or h2 == none {
    return false
  }
  h2.location().position().page >= h1.location().position().page
}

/// Truncates text content to a maximum length, adding ellipsis if needed
///
/// Example: `truncate-text([Very long text here], max-len: 10) // "Very lo..."`
///
/// - content (content): The content to truncate
/// - max-len (int): Maximum length before truncation. Default: `50`
/// -> content
#let truncate-text(content, max-len: 50) = {
  let text-str = to-string(content)
  if text-str.len() > max-len {
    [#text-str.slice(0, max-len - 3)...]
  } else {
    content
  }
}

/// Formats footer content with alternating layout for odd/even pages
///
/// Example: `format-footer([Chapter 1], counter(page).display())`
///
/// - left-content (content): Content for the left side on odd pages
/// - right-content (content): Content for the right side on odd pages
/// -> content
#let format-footer(left-content, right-content) = {
  if calc.odd(here().page()) {
    left-content
    h(1fr)
    right-content
  } else {
    right-content
    h(1fr)
    left-content
  }
}

/// Creates a single multiple choice question with enumerated answers
///
/// Example: `mcq([What is 2+2?], ([2], [3], [4], [5]))`
///
/// - question (content): The question text
/// - answers (array): Array of answer choices
/// -> content
#let mcq(question, answers) = [
  #question
  #set enum(numbering: "a)")
  #enum(..answers)
]

/// Creates multiple MCQs with automatic numbering
///
/// Example:
/// ```
/// mcqs((
///   ([What is 2+2?], ([2], [3], [4], [5])),
///   ([What is 3+3?], ([5], [6], [7], [8])),
/// ), title: [*Section A*], start: 1)
/// ```
///
/// - questions (array): Array of (question, answers) pairs
/// - title (content): Optional title above questions. Default: empty
/// - start (int): Starting number for question numbering. Default: `1`
/// -> content
#let mcqs(questions, title: [], start: 1) = [
  #title
  #for idx in range(questions.len()) [
    #numbering("1.", start + idx) #mcq(questions.at(idx).at(0), questions.at(idx).at(1))
  ]
]

/// Displays MCQ answers in a multi-column grid layout
///
/// Example: `mcq-answers(([A], [B], [C], [D]), columns: 2, title: [*Answers:*])`
///
/// - answers (array): Array of answer choices
/// - columns (int): Number of columns in the grid. Default: `3`
/// - start (int): Starting number for answer numbering. Default: `1`
/// - title (content): Optional title above answers. Default: empty
/// -> content
#let mcq-answers(answers, columns: 3, start: 1, title: []) = {
  let items = ()
  for idx in range(answers.len()) {
    items.push([#numbering("1.", start + idx) #answers.at(idx)])
  }
  title
  grid(
    columns: (1fr,) * columns,
    column-gutter: 1.5em,
    row-gutter: 0.65em,
    ..items
  )
}

/// Displays two pieces of content side-by-side with matched heights
///
/// Example: `matched-height-grid([Some text], image("image.png"), columns: (2fr, 1fr))`
///
/// - left (content): The left column content
/// - right (content): The right column content (height will match left)
/// - columns (array): Column widths as fractions. Default: `(2fr, 1fr)`
/// -> content
#let matched-height-grid(
  left,
  right,
  columns: (2fr, 1fr),
) = {
  layout(size => context {
    let total-fr = columns.at(0) + columns.at(1)
    let left-width = size.width * (columns.at(0) / total-fr)
    let left-height = measure(left, width: left-width).height

    grid(
      columns: columns,
      left,
      layout(cell-size => {
        box(
          width: cell-size.width,
          height: left-height,
          inset: 0.3em,
          align(center + horizon, right),
        )
      })
    )
  })
}

/// Creates a formatted lecture heading with automatic counter for a subject
///
/// This function provides explicit control over lecture headings with automatic
/// numbering per subject. Each subject maintains its own counter.
///
/// Example: `lec("Anatomy", "Oral Cavity, Pharynx, Esophagus, and Stomach")`
/// Output: "Lec. 1 Oral Cavity, Pharynx, Esophagus, and Stomach" (first anatomy lecture)
/// Output: "Lec. 2 [next title]" (second anatomy lecture)
///
/// - subject (string): The subject name (e.g., "Anatomy", "Histology")
/// - title (content or string): The lecture title
/// -> content
#let lec(subject, title) = {
  // Create a unique counter for each subject
  let lec-counter = counter("lec-" + subject)
  lec-counter.step()
  show heading: it => [#emph[Lec. #context lec-counter.display()] #h(0.3em) #it.body]
  heading(level: 2, outlined: true, bookmarked: true)[#title]
}
