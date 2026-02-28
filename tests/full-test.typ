#import "/src/lib.typ": *

#show: study-notes.with(
  title: "Biology 101 Notes",
  author: "Jane Doe",
  email: "jane@example.com",
  description: "Comprehensive biology notes",
  keywords: ("biology", "notes", "test"),
  quote-text: [The good thing about science is that it's true whether or not you believe in it.],
  quote-author: [Neil deGrasse Tyson],
)

= Anatomy

#lec("Anatomy", "The Skeletal System")

The human skeleton consists of 206 bones. Key functions include:

- Support and structure
- Protection of internal organs
- Movement (with muscles)
- Mineral storage

=== Bone Classification

+ Long bones (e.g., femur, humerus)
+ Short bones (e.g., carpals, tarsals)
+ Flat bones (e.g., skull, sternum)
+ Irregular bones (e.g., vertebrae)

#lec("Anatomy", "The Muscular System")

There are three types of muscle tissue:

#table(
  columns: (auto, 1fr, auto),
  table.header([*Type*], [*Description*], [*Voluntary?*]),
  [Skeletal], [Attached to bones, striated], [Yes],
  [Cardiac], [Heart muscle, striated], [No],
  [Smooth], [Walls of organs, non-striated], [No],
)

= Histology

#lec("Histology", "Epithelial Tissue")

Epithelial tissue lines body surfaces and cavities.

#matched-height-grid(
  [
    *Types of epithelium:*
    - Simple squamous
    - Simple cuboidal
    - Simple columnar
    - Stratified squamous
    - Pseudostratified columnar
    - Transitional
  ],
  align(center + horizon)[
    #rect(fill: blue.lighten(80%), inset: 1em)[
      _Diagram placeholder_
    ]
  ],
  columns: (2fr, 1fr),
)

= Practice Questions

#mcqs((
  ([Which bone is the longest in the human body?],
   ([Tibia], [Femur], [Humerus], [Fibula])),
  ([Which muscle type is involuntary and striated?],
   ([Skeletal], [Smooth], [Cardiac], [None])),
  ([What type of epithelium lines the alveoli?],
   ([Simple cuboidal], [Simple squamous], [Stratified squamous], [Transitional])),
), title: [*Section A: Multiple Choice*])

#mcq-answers(([b], [c], [b]), columns: 3, title: [*Answer Key:*])

= Summary

These notes covered:
+ The skeletal system and bone classification
+ Muscle tissue types and their properties
+ Epithelial tissue classification
+ Practice MCQs with answer keys

$ "Total bones" = 206 quad "Muscle types" = 3 $
