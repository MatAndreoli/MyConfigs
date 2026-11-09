# Slide visibility

Docs: slide-visibility. `data-visibility` on a `<section>`.

## Hidden (4.1+)

```html
<section>Slide 1</section>
<section data-visibility="hidden">Slide 2 (never shown)</section>
<section>Slide 3</section>
```

Removed from the DOM at init (`Reveal.removeHiddenSlides()` does it manually). Handy to park draft or alternate slides in a file without deleting them.

## Uncounted

```html
<section data-visibility="uncounted">Backup slide</section>
```

Still navigable, but excluded from slide numbering and the progress bar. **Only works for slides at the end** of the deck, after all main slides. Use for appendix/optional/"if there's time" slides.
