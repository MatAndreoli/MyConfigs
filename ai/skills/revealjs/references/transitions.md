# Transitions

Docs: transitions. Default slide transition is `slide`; default background transition is `fade`.

| Name | Effect |
|---|---|
| `none` | Instant |
| `fade` | Cross-fade |
| `slide` | Slide horizontally |
| `convex` | Slide at a convex angle |
| `concave` | Slide at a concave angle |
| `zoom` | Incoming slide grows from the center |

## Global

```js
Reveal.initialize({
  transition: 'fade',
  transitionSpeed: 'default',        // default | fast | slow
  backgroundTransition: 'fade',
});
```

## Per slide

```html
<section data-transition="zoom">...</section>
<section data-transition-speed="fast">...</section>
<section data-background-transition="slide">...</section>
```

## Separate in/out

Append `-in` / `-out`:

```html
<section data-transition="slide-in fade-out">and stops.</section>
<section data-transition="fade-in slide-out">(Passengers entering and leaving)</section>
```

## Related

For element-level morphing between two slides use `auto-animate.md`; for stepwise reveal use `fragments.md`. Consider `transition: 'none'` for decks exported to PDF/video or run in tests.
