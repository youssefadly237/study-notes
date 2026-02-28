# The `study-notes` Package

<div align="center">Version 0.1.0</div>

A Typst template for making nicely formatted study notes with a cover page, table of contents, breadcrumb footer navigation, MCQ utilities, and more.

## Getting Started

Import the package and apply the template show rule:

```typ
#import "@preview/study-notes:0.1.0": study-notes

#show: study-notes.with(
  title: "My Course Notes",
  author: "Your Name",
  email: "your.email@example.com",
  description: "Notes for Course 101",
  keywords: ("course", "notes"),
  quote-text: [An inspiring quote here.],
  quote-author: [Someone Famous],
)

= Introduction

Your content here...
```

### Installation

Install locally for development:

```
$ just install
```

Or use directly from the Typst package registry:

```typ
#import "@preview/study-notes:0.1.0": study-notes
```

## Usage

### Template Parameters

| Parameter      | Type     | Default            | Description                                    |
| -------------- | -------- | ------------------ | ---------------------------------------------- |
| `title`        | content  | `[]`               | Document title (shown on cover page)           |
| `author`       | content  | `[]`               | Author name(s)                                 |
| `email`        | content  | `none`             | Author email (makes author name a mailto link) |
| `description`  | content  | `[]`               | Document description for metadata              |
| `keywords`     | array    | `()`               | Keyword strings for metadata                   |
| `date`         | datetime | `datetime.today()` | Document date                                  |
| `paper`        | str      | `"a4"`             | Paper size                                     |
| `flipped`      | bool     | `false`            | Landscape orientation                          |
| `quote-text`   | content  | `[]`               | Quote for closing page                         |
| `quote-author` | content  | `[]`               | Quote attribution                              |
| `show-toc`     | bool     | `true`             | Show table of contents                         |
| `toc-depth`    | int      | `2`                | Depth of table of contents                     |

### MCQ Utilities

Create multiple choice questions:

```typ
#import "@preview/study-notes:0.1.0": mcq, mcqs, mcq-answers

#mcq([What is 2+2?], ([2], [3], [4], [5]))

#mcqs((
  ([What is 2+2?], ([2], [3], [4], [5])),
  ([What is 3+3?], ([5], [6], [7], [8])),
), title: [*Section A*])

#mcq-answers(([c], [b]), columns: 2, title: [*Answers:*])
```

### Lecture Headings

Auto-numbered lecture headings per subject:

```typ
#import "@preview/study-notes:0.1.0": lec

#lec("Anatomy", "Oral Cavity and Pharynx")
// Renders: "Lec. 1  Oral Cavity and Pharynx"

#lec("Anatomy", "Esophagus and Stomach")
// Renders: "Lec. 2  Esophagus and Stomach"
```

### Layout Utilities

```typ
#import "@preview/study-notes:0.1.0": matched-height-grid

#matched-height-grid(
  [Some text content on the left],
  image("figure.png"),
  columns: (2fr, 1fr),
)
```

## License

This project is licensed under MIT-0 - see [LICENSE](LICENSE) for details.
