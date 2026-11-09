# Fragments

Docs: fragments. Elements with class `fragment` are revealed one step at a time before the deck moves to the next slide. Default style: invisible, fade in.

```html
<p class="fragment">Fade in</p>
<p class="fragment fade-out">Fade out</p>
<p class="fragment highlight-red">Highlight red</p>
<p class="fragment fade-in-then-out">Fade in, then out</p>
<p class="fragment fade-up">Slide up while fading in</p>
```

## Styles

| Class | Effect |
|---|---|
| `fade-out` | Start visible, fade out |
| `fade-up` / `fade-down` / `fade-left` / `fade-right` | Slide in a direction while fading in |
| `fade-in-then-out` / `current-visible` | Fade in, then out on the next step |
| `fade-in-then-semi-out` | Fade in, then to 50% on the next step |
| `semi-fade-out` | Fade out to 50% |
| `grow` / `shrink` | Scale to 1.3× / 0.7× on the step. **Unlike the other styles they are visible before their step** (reveal.css gives them `opacity:1`), so they emphasize something already on the slide. Text scales from its center: add `style="display:inline-block"` or a `transform-origin` for inline text |
| `strike` | Strike through |
| `highlight-red` / `highlight-green` / `highlight-blue` | Color text |
| `highlight-current-red` / `-green` / `-blue` | Color, then revert on the next step |

## Custom fragments (4.5+)

Define `.fragment.<name>` (hidden state) and `.fragment.<name>.visible`; add class `custom` so reveal.js skips its default fade.

```html
<style>
  .fragment.blur { filter: blur(5px); }
  .fragment.blur.visible { filter: none; }
</style>
<p class="fragment custom blur">One</p>
<p class="fragment custom blur">Two</p>
```

Use `.current-fragment` instead of `.visible` to keep only the current step un-blurred.

## Nested (multi-step on one element)

```html
<span class="fragment fade-in">
  <span class="fragment highlight-red">
    <span class="fragment fade-out">Fade in > Turn red > Fade out</span>
  </span>
</span>
```

## Order

DOM order by default; override with `data-fragment-index` (same index = same step):

```html
<p class="fragment" data-fragment-index="3">Last</p>
<p class="fragment" data-fragment-index="1">First</p>
```

## Fragment step in the URL (for screenshots and links)

The hash is `#/<h>/<v>/<f>`, e.g. `deck.html#/3/0/1`. `<f>` is the **zero-based last visible step**: `-1` = no fragment shown, `0` = first step shown, `1` = first two steps, and a number past the end clamps to the last step (use `99` to capture the fully built slide). Fragments that share a `data-fragment-index` are one step. Step-by-step code highlights count as steps too. Verified: with two fragment steps, `#/1/0/-1` shows 0, `/0` shows 1, `/1` shows 2, `/2` shows 2. `fragmentInURL` must stay `true` (default) for the hash to update while presenting.

## Config & API

- `fragments: false` turns fragments off globally; `fragmentInURL: true` (default) puts the step in the URL hash.
- `Reveal.nextFragment()`, `prevFragment()`, `navigateFragment(i)` (-1 = all hidden), `availableFragments()`, `syncFragments()`.
- Events: `fragmentshown`, `fragmenthidden` (`event.fragment`).
- `data-autoslide` on a fragment sets its dwell time (see `auto-slide.md`).
- PDF export prints one page per fragment step by default (`pdfSeparateFragments`, see `pdf-export.md`).
- Markdown: `- Item <!-- .element: class="fragment" -->` (see `markdown.md`).
- With `r-stack`, fragments layer images in place (see `layout.md`).

## Gotchas

- Don't use fragments on every bullet by habit: each is a keypress; reserve for build-ups that earn it.
- Fragment elements inside a Markdown list item need the element comment, not a wrapper tag.
