# Links and slide addressing

Docs: links, jump-to-slide. Internal navigation without JavaScript.

## By id

```html
<section><a href="#/grand-finale">Go to the last slide</a></section>
<section id="grand-finale">
  <h2>The end</h2>
  <a href="#/0">Back to the first</a>
</section>
```

Give target sections a unique `id` (also useful for stable references and `G` jump).

## By index

`#/2` = 3rd horizontal slide (0-based by default; `hashOneBasedIndex: true` for 1-based). `#/3/2` = vertical slide 2 inside slide 3.

## Navigation buttons

Add to any clickable element inside `.reveal`:

```html
<button class="navigate-left">Left</button>
<button class="navigate-right">Right</button>
<button class="navigate-up">Up</button>
<button class="navigate-down">Down</button>
<button class="navigate-prev">Prev</button>  <!-- previous vertical OR horizontal -->
<button class="navigate-next">Next</button>
```

Valid routes get an `enabled` class (style disabled ones with CSS).

## Lightbox links

`<a href="https://..." data-preview-link>` opens the site in an iframe overlay if it allows embedding (see `lightbox.md`).

## URL hash

`hash: true` writes the slide to the URL (reload returns to it); `history: true` also pushes each slide to browser history (implies `hash`); `respondToHashChanges: true` (default) follows hash edits. Query strings like `?print-pdf`, `?view=scroll` are separate.

## Jump to slide (4.5+)

Press **G**, type a number or id, **Enter**: `5` → slide 5; `6/2` → horizontal 6, vertical 2; `the-end` → `<section id="the-end">`. Disable with `jumpToSlide: false`.
