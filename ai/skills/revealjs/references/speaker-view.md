# Speaker view and notes

Docs: speaker-view. Notes plugin (`RevealNotes`), press **S** to open the speaker window (current slide, next-slide preview, notes, timers).

```html
<script src=".../dist/plugin/notes.js"></script>
<script>Reveal.initialize({ plugins: [RevealNotes] });</script>
```

Requires a web server when used locally (not `file://`).

## Writing notes

```html
<section>
  <h2>Some Slide</h2>
  <aside class="notes">Private notes here.</aside>
</section>
```

- `<aside class="notes" data-markdown>` for Markdown notes.
- Or an attribute: `<section data-notes="Something important">`.
- In Markdown slides: a `Note:` line (see `markdown.md`, `data-separator-notes`).

## Showing notes to everyone / printing

`showNotes: true` shows notes along the bottom of the slides and includes them in PDF export (box over the slide). `showNotes: 'separate-page'` prints them on a separate page after each slide. See `pdf-export.md`. `showNotes` can be set at runtime via `Reveal.configure`.

## Timers

Speaker window shows elapsed time (click/hover to reset), wall clock, and optionally a pacing timer (green on track, red = speed up, blue = can slow down):

```js
Reveal.initialize({
  defaultTiming: 120,   // seconds per slide
  totalTime: 1800,      // total seconds; wins if both set
});
```

Per slide: `<section data-timing="90">`.

## Server-side notes

To run notes on a separate device use the Node.js notes-server: <https://github.com/reveal/notes-server>.

## API

`Reveal.getSlideNotes(slide)` returns a slide's notes.

Verified in headless Chrome: with `RevealNotes` registered, `Reveal.getPlugin('notes')` exists and `<aside class="notes">` and markdown `Note:` blocks are kept out of the visible slide. Opening the speaker window (press `S`) needs a real browser and a served page (`http://`), so it was not exercised headless.
