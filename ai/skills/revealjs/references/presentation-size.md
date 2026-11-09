# Presentation size, scaling, centering, embedding

Docs: presentation-size. A deck has a "normal" authoring resolution; reveal.js scales it uniformly to fit any viewport (aspect ratio preserved).

```js
Reveal.initialize({
  width: 960,        // default; can be a percentage string
  height: 700,       // default
  margin: 0.04,      // fraction of the display kept empty around content
  minScale: 0.2,
  maxScale: 2.0,
});
```

For a 16:9 deck set e.g. `width: 1280, height: 720` (or 1920×1080). All sizes in CSS are then relative to that canvas, so design at that size; the whole thing scales.

## Center

`center: true` (default) vertically centers each slide's content based on how much it has. `center: false` pins content to the top at the configured height: more predictable for content-heavy or consistently structured slides.

## Embedded

```js
Reveal.initialize({ embedded: true }); // size from the .reveal element, not the viewport
```

If the `.reveal` element changes size outside a window resize:

```js
document.querySelector('.reveal').style.width = '50vw';
Reveal.layout();
```

## BYOL (bring your own layout)

`disableLayout: true` turns off built-in scaling and centering; slides cover 100% of the page and responsive styling is yours.

## Agent notes

- Overflow: a slide taller than `height` overflows (it is not scrolled). Reduce content, split slides, or raise `height`.
- Related: `scroll-view.md` (responsive reading mode), `pdf-export.md` (page size is inferred from this size).
