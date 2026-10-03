/*
MCQ
*/

#import "utils.typ": truncate-text

#let _letter-to-idx(letter, q-num: none, choices-len: none) = {
  let s = upper(str(letter))
  let prefix = if q-num != none { "Q" + str(q-num) + ": " } else { "" }
  assert(
    s.len() == 1,
    message: prefix + "'" + str(letter) + "' is not a valid letter A-Z",
  )
  let code = s.to-unicode()
  let base = "A".to-unicode()
  assert(
    code >= base and code <= "Z".to-unicode(),
    message: prefix + "'" + str(letter) + "' is not a valid letter A-Z",
  )
  let idx = code - base
  if choices-len != none {
    assert(
      idx < choices-len,
      message: prefix
        + "'"
        + s
        + "' exceeds "
        + str(choices-len)
        + " available choices",
    )
  }
  idx
}


#let _idx-to-letter(idx) = str.from-unicode("A".to-unicode() + idx)

#let _answer-grid(count, num-columns, flip, cell-fn) = {
  if flip {
    columns(num-columns, gutter: 1.5em)[
      #for idx in range(count) {
        cell-fn(idx)
        linebreak()
      }
    ]
  } else {
    let rows = calc.ceil(count / num-columns)
    let items = range(rows * num-columns).map(idx => {
      if idx < count { cell-fn(idx) } else { [] }
    })
    grid(
      columns: (1fr,) * num-columns,
      column-gutter: 1.5em,
      row-gutter: 0.65em, ..items
    )
  }
}

#let _validate-questions(questions, start) = {
  for (idx, q) in questions.enumerate() {
    if type(q) != dictionary {
      panic(
        "Invalid question at index "
          + str(idx)
          + ": expected dictionary with keys 'question', 'choices', optional 'answer', got "
          + str(type(q)),
      )
    }
    if not ("question" in q and "choices" in q) {
      panic(
        "Invalid question at index "
          + str(idx)
          + ": dictionary must contain 'question' and 'choices' keys",
      )
    }
    let ans = q.at("answer", default: none)
    if ans != none {
      let _ = _letter-to-idx(
        ans,
        q-num: start + idx,
        choices-len: q.choices.len(),
      )
    }
  }
}

/// Creates a single multiple choice question with enumerated answers
///
/// Example: `mcq([What is 2+2?], ([2], [3], [4], [5]))`
///
/// - question (content): The question text
/// - choices (array): Array of answer content blocks
/// -> content
#let mcq(question, choices) = [
  #question
  #set enum(numbering: "a)")
  #enum(..choices)
]

/// Creates multiple MCQs with automatic numbering.
/// Each question is kept unbreakable across pages unless `breakable: true`.
///
/// Questions are dicts with keys: question (content), choices (array),
/// answer (str or none). The answer field is ignored here.
///
/// Example:
/// ```
/// #let qs = (
///   (question: "What is 2+2?", choices: ([3], [4], [5]), answer: "B"),
///   (question: "What is 3+3?", choices: ([5], [6], [7]), answer: none),
/// )
/// #mcqs(qs, title: [=== Questions])
/// ```
///
/// - questions (array): Array of question dicts
/// - title (content): Optional title. Default: `[]`
/// - start (int): Starting question number. Default: `1`
/// - breakable (bool): Allow page breaks inside a question. Default: `false`
/// -> content
#let mcqs(questions, title: [], start: 1, breakable: false) = {
  _validate-questions(questions, start)
  title
  enum(
    start: start,
    numbering: "1.",
    ..questions.map(q => block(breakable: breakable)[#mcq(
      q.question,
      q.choices,
    )]),
  )
}

/// Displays MCQ answers in a multi-column layout
///
/// Example: `mcq-answers(([A], [B], [C], [D]), columns: 2, title: [*Answers:*])`
///
/// - items (array): Array of answer choices
/// - columns (int): Number of columns. Default: `3`
/// - start (int): Starting number for answer numbering. Default: `1`
/// - title (content): Optional title above answers. Default: empty
/// - flip (bool): Fill column-by-column instead of row-by-row.
///   When `true`, uses page-aware columns that fill each page independently.
///   Default: `false`
/// -> content
#let mcq-answers(items, columns: 3, start: 1, title: [], flip: false) = {
  title
  _answer-grid(items.len(), columns, flip, src => [
    #numbering("1.", start + src) #items.at(src)
  ])
}

/// Displays MCQ answers with letter and inline answer text preview.
/// Shows "?" for questions with no answer (none).
/// Letters are validated against each question's own choice count.
///
/// - questions (array): Array of question dicts
/// - columns (int): Number of columns. Default: `3`
/// - start (int): Starting question number. Default: `1`
/// - title (content): Optional title. Default: `[]`
/// - flip (bool): Fill column-by-column instead of row-by-row.
///   When `true`, uses page-aware columns that fill each page independently.
///   Default: `false`
/// - preview-len (int): Max characters of answer text before ellipsis. Default: `50`
/// -> content
#let mcq-answers-preview(
  questions,
  columns: 3,
  start: 1,
  title: [],
  flip: false,
  preview-len: 50,
) = {
  _validate-questions(questions, start)
  title
  _answer-grid(questions.len(), columns, flip, src => {
    let q = questions.at(src)
    let ans = q.at("answer", default: none)
    if ans == none {
      [#numbering("1.", start + src) *?*]
    } else {
      let idx = _letter-to-idx(ans, choices-len: q.choices.len())
      [
        #numbering("1.", start + src) *#_idx-to-letter(idx)*#h(0.3em)#truncate-text(q.choices.at(idx), max-len: preview-len)]
    }
  })
}
