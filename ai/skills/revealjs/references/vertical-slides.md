# Vertical slides

Docs: vertical-slides.

Top-level `section`s are the horizontal sequence. Nest `section`s inside one to make a vertical stack, good for grouping a topic or tucking optional drill-down slides under a main one. The first nested slide is the stack's root and sits in the horizontal sequence.

```html
<section>Horizontal slide</section>
<section>
  <section>Vertical 1</section>
  <section>Vertical 2</section>
</section>
```

Right arrow skips past the rest of a stack; up/down arrows enter it. Space steps through everything.

## `navigationMode`

| Value | Behavior |
|---|---|
| `default` | Left/right = horizontal, up/down = vertical, space = all slides |
| `linear` | Removes up/down; left/right step through every slide (use for decks that should read as one line) |
| `grid` | Moving left/right between stacks keeps the vertical index (1.3 → 2.3 instead of 1.3 → 2.1) |

```js
Reveal.initialize({ navigationMode: 'linear' });
```

Only matters for decks that mix horizontal and vertical slides.

## Designing with stacks (tested with `assets/base-styles.css`)

Use a stack when a topic has an overview plus supporting detail, so a presenter can go straight through the overview slides and dive into detail only when asked. Typical structure: one column per topic.

```html
<section id="intro" class="title-slide">...</section>

<section id="costs">                                   <!-- stack: one column = one topic -->
  <section id="costs-overview">                        <!-- first slide = the topic's overview (this is what the horizontal flow shows) -->
    <p class="eyebrow">Costs</p><h2>Pings cost less than one cold write</h2>
    <div class="content">...</div>
  </section>
  <section id="costs-chart"><p class="eyebrow">Costs · detail</p><h2>...</h2>...</section>
  <section id="costs-table"><p class="eyebrow">Costs · detail</p><h2>...</h2>...</section>
</section>

<section id="close" class="title-slide">...</section>
```

Rules:
- **The first slide of a stack must stand alone.** Anyone who never presses down should still get the point.
- **Put the topic in the `.eyebrow` of every slide in the stack** (`Costs`, `Costs · detail`) so people always know where they are.
- Nothing essential goes only in a lower slide: the presenter may skip it, and scroll/PDF views flatten stacks (the detail slides appear in order).
- Show that more exists: `controlsLayout: 'edges'` puts the down arrow at the bottom of the screen, and `slideNumber: 'c/t'` counts every slide. The default controls are small and bottom-right.
- Keep stacks to 2-5 slides. Longer = make it its own horizontal topic.
- The starter stylesheet needs nothing extra for stacks (verified: the stack wrapper and nested slides lay out normally).
- Prefer `navigationMode: 'default'` for drill-down. Use `'linear'` only if the audience reads the deck without a presenter.

## Agent notes

- Presenters often forget up/down exists; if a deck is meant to be read linearly, use `linear` or avoid stacks.
- Scroll view flattens stacks into one flow (see `scroll-view.md`).
- Markdown separators for vertical slides: `data-separator-vertical` (see `markdown.md`).
- Both PDF export and `slideNumber` ("h.v") account for vertical slides; use `c` or `c/t` for flat numbering (see `slide-numbers.md`).
