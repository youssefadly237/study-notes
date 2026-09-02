/*
Layout
*/

/// Displays two pieces of content side-by-side with matched heights
///
/// Example: `side-by-side([Some text], image("image.png"), columns: (2fr, 1fr))`
///
/// - left (content): The left column content
/// - right (content): The right column content (height will match left)
/// - columns (array): Column widths as fractions. Default: `(2fr, 1fr)`
/// -> content
#let side-by-side(
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

/// Creates a formatted lecture heading with automatic counter for a subject.
///
/// Renders a weak pagebreak before the heading, then the label "Lec. N" in
/// italics, a full-width horizontal rule, and the lecture title as a level-2
/// heading. Each subject maintains its own counter.
///
/// Example: `#lec("Anatomy", "Oral Cavity, Pharynx, Esophagus, and Stomach")`
/// Output: "Lec. 1" / line / "Oral Cavity, Pharynx, Esophagus, and Stomach"
///
/// - subject (string): The subject name (e.g., "Anatomy", "Histology")
/// - title (content or string): The lecture title
/// - prefix (auto or string): Label shown before the counter (or as standalone text
///   when counted is false). `auto` uses "Lec". Default: `auto`
/// - counted (bool): Whether to show and increment the counter. Default: `true`
/// -> content
#let lec(subject, title, prefix: auto, counted: true) = {
  let lec-counter = counter("lec-" + subject)
  let resolved-prefix = if prefix == auto { "Lec" } else { prefix }

  if counted {
    lec-counter.step()
  }

  pagebreak(weak: true)
  v(0.5em)
  if counted {
    text(size: 1.2em)[#resolved-prefix. #context lec-counter.display()]
  } else {
    text(size: 1.2em)[#resolved-prefix]
  }
  v(-0.9em)
  line(length: 100%)
  v(-0.9em)
  show heading.where(level: 2): set heading(hanging-indent: 0pt)
  show heading.where(level: 2): set text(size: 1.4em)
  heading(level: 2, outlined: true, bookmarked: true)[#title]
  v(1em)
}

/// Creates a full-page section divider with a centered title and an optional
/// mini-TOC of headings that follow, up to the next section.
///
/// Stores the title as #metadata under <section-anchor> for querying. Renders the
/// title as a level-1 heading at enlarged size, centered on the page. The TOC lists
/// all headings from level 2 down to `toc-depth` with dot leaders and clickable
/// page numbers.
///
/// Example: `#section("Gastrointestinal System")`
/// Example: `#section("Gastrointestinal System", toc-depth: 3)`
/// Example: `#section("Gastrointestinal System", show-toc: false)`
///
/// - title (content or string): The section title, also registered in the outline
///   and PDF bookmarks.
/// - toc-depth (int): Deepest heading level to include in the mini-TOC. Minimum 2.
///   Default: `2`
/// - show-toc (bool): Whether to show the mini-TOC. Default: `true`
/// -> content
#let section(title, toc-depth: 2, show-toc: true) = {
  pagebreak(weak: true)
  [#metadata(title)<section-anchor>]
  page(margin: (x: 3cm, y: 4cm))[
    #align(center + horizon)[
      #show heading.where(level: 1): set text(size: 3em)
      #heading(level: 1, outlined: true)[#title]
      #if show-toc [
        #v(2em)
        #context {
          let depth = calc.max(toc-depth, 2)
          let sel = range(2, depth + 1).fold(
            heading.where(level: 2),
            (s, l) => if l == 2 { s } else { s.or(heading.where(level: l)) },
          )
          let next-h1-query = query(
            selector(heading.where(level: 1)).after(here()),
          )
          let scoped = if next-h1-query.len() > 0 {
            sel.after(here()).before(next-h1-query.at(0).location())
          } else {
            sel.after(here())
          }
          outline(title: none, indent: auto, target: scoped, depth: depth)
        }
      ]
    ]
  ]
}

/// Wraps `content` in a block and places a small badge `label` either
/// on the side (left, vertically centered) or on top (centered above).
/// Single-sided (always left for `side`).
///
/// Example: `#nb[NB][Some content that gets the badge]`
/// Example: `#nb(pos: "top")[NB][Content with badge on top]`
/// Example: `#nb(shape: "square", fill: red)[!][Content]`
///
/// - label (content | string): The short label to show in the badge
/// - content (content): The main content the badge is attached to
/// - pos (str): Where to place the badge: `"side"` (left, `horizon`) or
///   `"top"` (above, `top+center`). Default: `"side"`
/// - shape (str): The shape to use: "circle", "ellipse", or "square". Default: `"ellipse"`
/// - fill (color): Background fill for the shape. Default: `black`
/// - stroke (stroke): Stroke for the shape. Default: `none`
/// -> content
#let nb(
  label,
  content,
  pos: "side",
  shape: "ellipse",
  fill: black,
  stroke: none,
) = {
  let marker = align(center + horizon, text(
    size: 0.7em,
    weight: "bold",
    fill: white,
  )[#label])
  let shaped = if shape == "circle" {
    circle(radius: 0.6em, marker, fill: fill, stroke: stroke)
  } else if shape == "square" {
    square(size: 1.2em, marker, fill: fill, stroke: stroke)
  } else {
    ellipse(width: 1.6em, height: 1.2em, marker, fill: fill, stroke: stroke)
  }
  block[
    #content
    #if pos == "top" {
      place(left + top, dx: -3.4em, shaped)
    } else if pos == "side" {
      place(left + horizon, dx: -3.4em, shaped)
    } else {
      panic("invalid pos " + repr(pos) + ": expected \"top\" or \"side\"")
    }
  ]
}

/// Draws a line from `start` to `end` and places `label` just beyond `end`
/// along the same direction, offset by `padding`.
///
/// - start (array): Start point as `(x, y)` length pair
/// - end (array): End point as `(x, y)` length pair
/// - label (content): Content placed beyond the line end
/// - padding (length): Gap between line end and label. Default: `6pt`
/// -> content
#let annotation(start, end, label, padding: 6pt) = context {
  let size = measure(label)
  let dx = (end.at(0) - start.at(0)) / 1pt
  let dy = (end.at(1) - start.at(1)) / 1pt
  let len = calc.sqrt(dx * dx + dy * dy)
  let (nx, ny) = if len > 0 { (dx / len, dy / len) } else { (0, 0) }

  let center = (
    end.at(0) + nx * (size.width / 2 + padding),
    end.at(1) + ny * (size.height / 2 + padding),
  )

  place(top + left, line(start: start, end: end))
  place(top + left, move(
    dx: center.at(0) - size.width / 2,
    dy: center.at(1) - size.height / 2,
  )[#label])
}


