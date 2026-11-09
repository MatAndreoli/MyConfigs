# Presenting code

Docs: code. highlight.js via the highlight plugin.

```html
<link rel="stylesheet" href=".../dist/plugin/highlight/monokai.css" />
<script src=".../dist/plugin/highlight.js"></script>
<script>Reveal.initialize({ plugins: [RevealHighlight] });</script>
```

Other highlight themes: <https://highlightjs.org/demo/> (swap the CSS).

## Basic block

```html
<pre><code data-trim data-noescape>
(def lazy-fib (concat [0 1] ...))
</code></pre>
```

- `data-trim`: strip surrounding whitespace/indentation.
- `data-noescape`: don't HTML-escape the content (to put markup like `<mark>` inside).

## Line numbers and highlights

```html
<pre><code data-line-numbers="3,8-10">...</code></pre>   <!-- highlight lines 3 and 8-10 -->
<pre><code data-line-numbers>...</code></pre>             <!-- numbers only -->
```

### Offset (4.2+)

```html
<pre><code data-line-numbers data-ln-start-from="7">...</code></pre>
```

### Step-by-step highlights

`|` separates steps; each step is a fragment-like press:

```html
<pre><code data-line-numbers="3-5|8-10|13-15">...</code></pre>
```

## Language

Auto-detected; force with a class:

```html
<pre><code data-trim class="language-python">...</code></pre>
```

## HTML entities (4.1+)

HTML in `<code>` is parsed by the browser: `<` and `>` must be `&lt;`/`&gt;`. Or wrap in a template and reveal.js escapes for you:

```html
<pre><code><script type="text/template">
sealed class Either<out A, out B> { ... }
</script></code></pre>
```

## highlight.js hooks

```js
Reveal.initialize({
  highlight: {
    beforeHighlight: (hljs) => hljs.registerLanguage(/* ... */), // 4.2+
    highlightOnLoad: false,                                      // manual mode
  },
  plugins: [RevealHighlight],
}).then(() => {
  Reveal.getPlugin('highlight').highlightBlock(codeEl);
});
```

## In Markdown

````markdown
```js [1-2|3|4]
...
```
````

Offset: ```` ```js [712: 1-2|3|4] ````. See `markdown.md`.

## Animating between code blocks

Use `data-line-numbers` plus the same `data-id` on the `<pre>`s of adjacent `data-auto-animate` slides (see `auto-animate.md`).

## Gotchas

- Code that is long overflows the slide; show an excerpt with `data-ln-start-from`, or split across steps.
- Indented templates: always add `data-trim`, otherwise the first line's leading whitespace shows.
- **Step numbers:** the first highlight group is already shown when the slide opens, so a code block with N groups has N-1 fragment steps. In the URL `#/h/v/-1` is group 1, `/0` is group 2, ... `check-deck.py` takes one screenshot per step. Dimming of the other lines only works because `base-styles.css` makes each stacked `<code>` copy opaque; with transparent copies every line looks lit. The same file recolors Monokai's comment grey (below 4.5:1 on the dark panel) to `--muted`.
- With step highlights (`data-line-numbers="1|2-3"`) the plugin wraps the `<pre>` in `.code-wrapper` and stacks one `<code>` copy per step. In a flex column the box can come out shorter than its content, so a caption placed **below** it overlaps. `assets/base-styles.css` already fixes this (grid-stacked copies, panel on the `<pre>`). If you use your own CSS, put captions above or beside the code, and re-check with a screenshot while stepping through every step.
- Monokai's background is a fixed grey. With a custom palette, restyle the **`<pre>`** background (not each `<code>`), or pick another highlight.js theme CSS.
