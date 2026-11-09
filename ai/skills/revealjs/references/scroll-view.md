# Scroll view (5.0+)

Docs: scroll-view. Any deck can be shown as a scrollable page; fragments, animations and auto-animate keep working. Present in slide view, share in scroll view.

Vertical stacks are flattened: all slides appear in authored order.

## Activate

```js
Reveal.initialize({ view: 'scroll', scrollProgress: true });
```

Or without changing config: append `?view=scroll` to the URL.

## Automatic activation

Scroll view turns on automatically at mobile widths. Controlled by `scrollActivationWidth` (default **435** px); set `null` or `0` to disable.

## Options

| Option | Values | Notes |
|---|---|---|
| `view` | `'scroll'` | Start in scroll view |
| `scrollProgress` | `'auto'` (default), `true`, `false` | Custom scrollbar, segmented by slide and fragment; `auto` hides when idle |
| `scrollSnap` | `'mandatory'`, `'proximity'`, `false` | Snap to nearest slide / only when close / continuous |
| `scrollLayout` | `'full'` (default), `'compact'` (experimental) | `full`: each slide as tall as the viewport. `compact`: slide as wide as the viewport, tall per aspect ratio, multiple visible |
| `scrollActivationWidth` | px or `null` | Width below which scroll view auto-activates |

Example deck: <https://slides.com/news/scroll-mode/scroll>.
- Verified: loading the deck with `?view=scroll` gives `Reveal.getConfig().view === 'scroll'` and `Reveal.isScrollView() === true` (the default view is `null`). Plugins (KaTeX, markdown, highlight, notes) all work in it.
