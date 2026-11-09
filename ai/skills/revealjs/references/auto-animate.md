# Auto-Animate (4.0+)

Docs: auto-animate. Put `data-auto-animate` on **two adjacent** `<section>`s; matching elements animate between them.

```html
<section data-auto-animate>
  <h1>Auto-Animate</h1>
</section>
<section data-auto-animate>
  <h1 style="margin-top: 100px; color: red;">Auto-Animate</h1>
</section>
```

Animatable: `position`, `font-size`, `line-height`, `color`, `background-color`, `padding`, `margin`, etc. (movement uses CSS transforms internally). Added/removed/rearranged elements also move into place:

```html
<section data-auto-animate><h1>Implicit</h1></section>
<section data-auto-animate><h1>Implicit</h1><h1>Animation</h1></section>
```

## How elements match

- Text: same text content and node type.
- img/video/iframe: same `src`.
- Also considers DOM order.
- Explicit: matching `data-id` on both elements; **takes priority**. Required when there's no content to match on (empty boxes, changed text).

```html
<section data-auto-animate><div data-id="box" style="height:50px;background:salmon"></div></section>
<section data-auto-animate><div data-id="box" style="height:200px;background:blue"></div></section>
```

## Settings (per slide or per element)

| Attribute | Default | Meaning |
|---|---|---|
| `data-auto-animate-easing` | `ease` | CSS easing |
| `data-auto-animate-unmatched` | `true` | Fade in unmatched elements; `false` = appear instantly |
| `data-auto-animate-duration` | `1.0` | Seconds |
| `data-auto-animate-delay` | `0` | Seconds; element-level only |
| `data-auto-animate-id` | absent | Only same-id (or both id-less) adjacent slides animate |
| `data-auto-animate-restart` | absent | Break animation between the previous slide and this one |

Global defaults:

```js
Reveal.initialize({
  autoAnimate: true,              // false disables globally
  autoAnimateEasing: 'ease-out',
  autoAnimateDuration: 0.8,
  autoAnimateUnmatched: false,
  autoAnimateStyles: ['opacity','color','background-color','padding','font-size','line-height','letter-spacing','border-width','border-color','border-radius','outline','outline-offset'],
  autoAnimateMatcher: null,       // custom element matcher
});
```

## Groups

```html
<section data-auto-animate>Group A</section>
<section data-auto-animate>Group A, changed</section>
<section data-auto-animate data-auto-animate-id="two">Group B</section>
<section data-auto-animate data-auto-animate-id="two">Group B, changed</section>
<section data-auto-animate data-auto-animate-id="two" data-auto-animate-restart>Group C</section>
```

## Code blocks

Needs `data-line-numbers` on each `<code>` and the same `data-id` on each `<pre>`:

```html
<section data-auto-animate>
  <pre data-id="code-animation"><code data-trim data-line-numbers>
    let planets = [{ name: 'mars' }]
  </code></pre>
</section>
<section data-auto-animate>
  <pre data-id="code-animation"><code data-trim data-line-numbers>
    let planets = [{ name: 'mars' }, { name: 'earth' }]
  </code></pre>
</section>
```

## Lists

List items match individually, so added/removed `<li>` animate in/out.

## State attributes (for custom CSS)

- Incoming `<section>` gets `data-auto-animate="pending"` (elements at start positions), then `"running"`.
- Each animated element gets `data-auto-animate-target="<id>"` or `"unmatched"`.

## Event

```js
Reveal.on('autoanimate', (e) => { /* e.fromSlide, e.toSlide */ });
```

## Gotchas

- Slides must be adjacent; a slide without the attribute between them breaks it.
- Inline `style` or CSS class changes between the slides is the whole mechanism: write slide B as slide A plus a delta.
