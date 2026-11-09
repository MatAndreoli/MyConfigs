# Events

Docs: events. `Reveal.on(name, fn)` / `Reveal.off(name, fn)`.

| Event | Payload / when |
|---|---|
| `ready` | Non-async deps loaded, API usable. `event.currentSlide, indexh, indexv`. `Reveal.isReady()`; `.ready` class on `.reveal`; `initialize()` Promise resolves at the same time |
| `slidechanged` | Fires instantly on change. `event.previousSlide, currentSlide, indexh, indexv` |
| `slidetransitionend` | After transition finishes; same payload. Use for work that needs the slide fully visible |
| `resize` | Scale changed. `event.scale, oldScale, size` |
| `fragmentshown` / `fragmenthidden` | `event.fragment` |
| `overviewshown` / `overviewhidden` | Overview toggled |
| `autoslidepaused` / `autoslideresumed` | Auto-slide state |
| `autoanimate` | Between auto-animated slides: `event.fromSlide, toSlide` |
| `<data-state value>` | Fires when a slide with that `data-state` opens (`setup.md`) |

```js
Reveal.on('slidechanged', (event) => {
  // e.g. re-render a chart or call MathJax typeset; both can misbehave under slide transforms
});
```

Other libs (charts, MathJax) often need a redraw on `slidechanged`/`slidetransitionend` because slides are transformed and hidden.

Events can be forwarded to a parent window (`postMessageEvents: true`; `postmessage.md`).
