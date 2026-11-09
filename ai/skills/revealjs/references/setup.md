# Setup, markup and initialization

Docs: installation, markup, initialization. Verified against reveal.js 6.0.2.

## Zero-build deck (preferred for agents)

One HTML file, assets from the jsDelivr CDN. Pin the version. Opens from `file://`, except for the features listed under "Needs a web server".

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Deck title</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/reset.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/reveal.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/theme/black.css" />
    <!-- syntax-highlight theme, only if using the highlight plugin -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/plugin/highlight/monokai.css" />
  </head>
  <body>
    <div class="reveal">
      <div class="slides">
        <section>Slide 1</section>
        <section>Slide 2</section>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/reveal.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/plugin/notes.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/plugin/markdown.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/plugin/highlight.js"></script>
    <script>
      Reveal.initialize({
        hash: true,
        plugins: [RevealMarkdown, RevealHighlight, RevealNotes],
      });
    </script>
  </body>
</html>
```

**Integrity:** for production or shared decks add `integrity="sha384-..."` and `crossorigin="anonymous"` to each CDN `<script>`/`<link>` (generate the hash from the pinned file), or vendor the files locally. Hash command: `curl -s <url> | openssl dgst -sha384 -binary | openssl base64 -A`, then `integrity="sha384-<output>"`; a wrong hash makes the browser block the file, so reload the deck after adding it. Unpinned or unchecked CDN scripts run with full page access.

Files available under `dist/`: `reveal.js` (global `Reveal`), `reveal.mjs` (ES module), `reveal.css`, `reset.css`, `theme/*.css`, `plugin/{highlight,markdown,notes,math,search,zoom}.{js,mjs}`, `plugin/highlight/*.css`.

## Install options

| Setup | How | Use when |
|---|---|---|
| Basic | Download the repo zip, edit `index.html`, open in a browser | No tooling at all |
| Full | `git clone https://github.com/hakimel/reveal.js.git && cd reveal.js && npm install && npm start` (Node 20.19+, serves :8000, `npm start -- --port=8001`) | Need a dev server, or edit reveal source |
| npm | `npm install reveal.js`, then `import Reveal from 'reveal.js'; import 'reveal.js/reveal.css'; import 'reveal.js/theme/black.css';` | Bundled app, or React (see `react.md`) |

```js
import Reveal from 'reveal.js';
import Markdown from 'reveal.js/plugin/markdown';
let deck = new Reveal({ plugins: [Markdown] });
deck.initialize();
```

## Needs a web server (not `file://`)

- External Markdown (`data-markdown="file.md"`)
- Speaker view (`notes` plugin), when used locally

Serve with `npx http-server .`, `python3 -m http.server`, or `npm start`.

## Markup hierarchy

`.reveal > .slides > section`. A `section` is one slide.

```html
<div class="reveal">
  <div class="slides">
    <section>Horizontal slide</section>
    <section>
      <section>Vertical 1</section>
      <section>Vertical 2</section>
    </section>
  </div>
</div>
```

Nested sections become a vertical stack; see `vertical-slides.md`.

## Viewport

The wrapper element that sets deck size is `body` by default (each `.reveal` when multiple decks). It always has the `reveal-viewport` class after init.

## Slide states

`<section data-state="make-it-pop">` adds the class `make-it-pop` to the viewport while the slide is open. Use it for deck-wide style changes per slide. JS: `Reveal.on('make-it-pop', () => {})`.

```css
.make-it-pop { filter: drop-shadow(0 0 10px purple); }
```

## Initialization

```js
Reveal.initialize({ transition: 'none' });          // global Reveal, one deck per page
Reveal.initialize().then(() => { /* ready */ });     // returns a Promise
Reveal.destroy();                                    // undo DOM changes, listeners, plugins (4.3+)
```

### Multiple decks on one page (4.0+)

```html
<div class="reveal deck1">...</div>
<div class="reveal deck2">...</div>
<script type="module">
  import Reveal from 'reveal.js';
  let deck1 = new Reveal(document.querySelector('.deck1'), {
    embedded: true,
    keyboardCondition: 'focused', // only react to keys when focused
  });
  deck1.initialize();
</script>
```

Each `.reveal` needs explicit CSS `width`/`height`, and `embedded: true` (see `presentation-size.md`). Use the instance (`deck1.next()`), not the global `Reveal`.

### ES module bundle

`dist/reveal.mjs` and `dist/plugin/*.mjs` work with `<script type="module">` or a bundler. Plugin imports are default exports (`import Markdown from 'dist/plugin/markdown.mjs'`).
