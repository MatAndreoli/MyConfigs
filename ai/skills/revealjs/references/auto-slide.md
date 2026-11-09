# Auto-slide (kiosk / self-running decks)

Docs: auto-slide.

```js
Reveal.initialize({
  autoSlide: 5000,        // ms between slides; 0 = only where data-autoslide is set; false = never
  loop: true,
  autoSlideStoppable: true, // default; false removes the play/pause control and stop-on-interaction
});
```

A play/pause control appears; sliding pauses when the user interacts; **A** toggles it.

## Per slide / fragment timing

```html
<section data-autoslide="2000">
  <p>After 2s the first fragment shows.</p>
  <p class="fragment" data-autoslide="10000">After 10s the next shows.</p>
  <p class="fragment">Shown 2s, then next slide.</p>
</section>
```

## Navigation method

Steps through horizontal and vertical slides by default. To skip vertical stacks:

```js
Reveal.configure({ autoSlideMethod: () => Reveal.right() });
```

## API/events

`Reveal.toggleAutoSlide()`, `Reveal.isAutoSliding()`; events `autoslidepaused`, `autoslideresumed`.
