#import "/src/lib.typ": *

// Test to-string utility
#assert.eq(to-string([Hello]), "Hello")
#assert.eq(to-string([Hello World]), "Hello World")

// Test truncate-text
#assert.eq(to-string(truncate-text([Short], max-len: 50)), "Short")
#assert.eq(
  to-string(truncate-text([This is a very long text that should be truncated], max-len: 20)),
  "This is a very lo\u{2026}",
)
