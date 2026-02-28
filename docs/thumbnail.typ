#import "/src/lib.typ": *

#set page(height: auto, margin: 5mm, fill: none)

// style thumbnail for light and dark theme
#let theme = sys.inputs.at("theme", default: "light")
#set text(white) if theme == "dark"

#set text(22pt)
#align(center)[
  #text(size: 28pt, weight: "bold")[study-notes]
  #v(0.3em)
  #text(size: 14pt, style: "italic")[Nicely formatted academic notes]
  #v(0.8em)
  #text(size: 12pt)[Cover page - TOC - Breadcrumb footers - MCQ utilities]
]
