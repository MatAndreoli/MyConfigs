# PDF export

Docs: pdf-export. Done with a print stylesheet; confirmed in Chrome/Chromium only.

## Manual

1. Open the deck with `?print-pdf`: `http://localhost:8000/?print-pdf`.
2. Print (Ctrl/Cmd+P), destination **Save as PDF**.
3. Layout **Landscape**, margins **None**, enable **Background graphics**.

## Command line

Docs mention decktape as an alternative: `npx decktape reveal "deck.html" out.pdf` (also `--screenshots` for per-slide PNGs, useful for visual review).

## Config

```js
Reveal.configure({
  showNotes: true,                // notes in an overlay box; 'separate-page' prints them after the slide
  pdfMaxPagesPerSlide: 1,         // cap pages a tall slide can expand onto (default unlimited)
  pdfSeparateFragments: false,    // true (default): one page per fragment step
  pdfPageHeightOffset: -1,        // environment tweak; -1 for in-browser printing
});
```

- Page numbers: enable `slideNumber` (see `slide-numbers.md`); `showSlideNumber: 'print'` shows them only in print.
- Page size is inferred from the deck `width`/`height` (see `presentation-size.md`).
- Slides too tall for a page spill onto more pages; fix content, or cap with `pdfMaxPagesPerSlide: 1` and shrink content.

## Agent notes

- Background graphics must be on or colored/image backgrounds vanish.
- Fragments multiply pages; set `pdfSeparateFragments: false` for a compact handout.

## Verified from the command line

`google-chrome --headless --no-pdf-header-footer --virtual-time-budget=9000 --print-to-pdf=out.pdf "file:///path/deck.html?print-pdf"` produced a PDF with KaTeX math, markdown slides and code steps intact. A 9-slide deck with 4 fragment/highlight steps gave 12 pages (one extra page per step while `pdfSeparateFragments` is true). In this mode `Reveal.getConfig().view === 'print'`.
