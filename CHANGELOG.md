# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.3] - 2026-09-02

### Added

- Structured MCQ data with answer validation and answer previews
- Split MCQ, layout, and utility functionality into dedicated modules
  (`mcq.typ`, `layout.typ`, `utils.typ`)
- `fmt` recipe using `typstyle` for automated formatting

### Changed

- **BREAKING:** Rename `matched-height-grid` to `side-by-side` - update imports
  from `matched-height-grid` to `side-by-side`
  (`#import "@preview/study-notes:0.1.3": side-by-side`)
- **BREAKING:** `nb` now requires `nb[label][content]` (was `nb[label]` with
  loose content) - wraps `content` in a `block` with badge placed via `place`;
  adds `pos` parameter (`"side"` / `"top"`), e.g., `#nb[imp][Text]` instead of
  `#nb[imp] Text` and `#nb(shape: "square", fill: red)[!][Text]` instead of
  `#nb[!, shape: "square", fill: red] Text`
- Improve heading numbering, alignment, sizing, and hanging indentation
- Configure skewed math fractions for improved rendering
- Update tests, documentation, and template examples for renamed APIs
- Apply formatting and markdown lint fixes across the project
- Bumped version to 0.1.3

### Removed

- Remove obsolete `config.typ` (functionality split into `layout.typ` and
  `study-notes.typ`)

## [0.1.2] - 2026-05-07

### Added

- `mcq-answers` now accepts `flip` parameter for column-by-column filling
- `lec` now accepts `prefix` and `counted` parameters for custom labels

### Changed

- Bumped version to 0.1.2

## [0.1.1] - 2026-04-30

### Added

- `section` function for full-page section dividers with optional mini-TOC
- `nb` function for margin notes with configurable shapes and colors

### Changed

- `lec` now renders a weak pagebreak, "Lec. N" label, horizontal rule, and
  level-2 heading
- Bumped version to 0.1.1

## [0.1.0]

### Added

- Initial template with cover page, table of contents, and breadcrumb footers
- MCQ utilities (`mcq`, `mcqs`, `mcq-answers`)
- Auto-numbered lecture headings (`lec`)
- Matched-height side-by-side grid layout
- Closing quote page support
- Package manual

[Unreleased]:
  https://github.com/youssefadly237/study-notes/compare/v0.1.3...HEAD
[0.1.3]: https://github.com/youssefadly237/study-notes/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/youssefadly237/study-notes/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/youssefadly237/study-notes/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/youssefadly237/study-notes/releases/tag/v0.1.0
