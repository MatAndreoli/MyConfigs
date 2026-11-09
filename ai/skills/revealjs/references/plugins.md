# Plugins (built-in, using, creating)

Docs: plugins, creating-plugins, multiplex. Using one = include the script (+ CSS if needed) **and** list it in `plugins`.

```html
<script src=".../dist/plugin/markdown.js"></script>
<script>Reveal.initialize({ plugins: [RevealMarkdown] });</script>
```

ES modules: `import Markdown from 'dist/plugin/markdown.mjs'; Reveal.initialize({ plugins: [Markdown] });`

## Built-in

| Global | File | Purpose | Reference |
|---|---|---|---|
| `RevealHighlight` | `dist/plugin/highlight.js` (+ `highlight/*.css`) | Syntax highlighting | `code.md` |
| `RevealMarkdown` | `dist/plugin/markdown.js` | Markdown slides | `markdown.md` |
| `RevealNotes` | `dist/plugin/notes.js` | Speaker view | `speaker-view.md` |
| `RevealMath.KaTeX` / `.MathJax2/3/4` | `dist/plugin/math.js` | Equations | `math.md` |
| `RevealSearch` | `dist/plugin/search.js` | Ctrl+Shift+F search | n/a |
| `RevealZoom` | `dist/plugin/zoom.js` | Alt+click zoom (Ctrl+click on Linux) | n/a |

Every one also ships as `.mjs`. Multiplex (audience follows presenter on their own device) lives in its own repo: <https://github.com/reveal/multiplex>.

## Plugin API

```js
Reveal.hasPlugin('markdown');   // true
Reveal.getPlugin('markdown');   // { id: 'markdown', init }
Reveal.getPlugins();            // map of all
Reveal.registerPlugin(Plugin);  // runtime registration
```

## Creating a plugin (4.0+)

Object with `id` (required, unique), optional `init(deck)` (may return a Promise: reveal.js waits for it before firing `ready`), optional `destroy()`. Export a **factory** so each deck instance gets its own copy.

```js
// toaster.js
export default () => ({
  id: 'toaster',
  init: (deck) => {
    deck.addKeyBinding({ keyCode: 84, key: 'T', description: 'Shuffle' }, () => deck.shuffle());
  },
});
```

```js
import Toaster from './toaster.js';
Reveal.initialize({ plugins: [Toaster] });
```

Async: `init: () => new Promise((resolve) => setTimeout(resolve, 3000))`.

## Deprecated `dependencies` (since 4.0)

`Reveal.initialize({ dependencies: [{ src, async, callback, condition }] })` still works for backward compatibility; prefer `<script defer>` tags plus `plugins`.
