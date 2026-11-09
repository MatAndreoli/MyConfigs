# Markdown slides

Docs: markdown. Powered by the built-in Markdown plugin (marked). Register: `<script src=".../plugin/markdown.js">` + `plugins: [RevealMarkdown]`.

## Inline

```html
<section data-markdown>
  <textarea data-template>
    ## Slide 1
    A paragraph with a [link](https://example.com).
    ---
    ## Slide 2
    ---
    ## Slide 3
  </textarea>
</section>
```

- `---` on its own line separates horizontal slides.
- Sensitive to indentation: don't mix tabs and spaces, avoid consecutive blank lines.
- `<script type="text/template">` works in place of the `textarea`.

## External file (needs a web server)

```html
<section
  data-markdown="example.md"
  data-separator="^\n\n\n"
  data-separator-vertical="^\n\n"
  data-separator-notes="^Note:"
  data-charset="iso-8859-15"
></section>
```

| Attribute | Default | Meaning |
|---|---|---|
| `data-separator` | `^\r?\n---\r?\n$` | Regex for horizontal slide breaks |
| `data-separator-vertical` | disabled | Regex for vertical slide breaks |
| `data-separator-notes` | `notes?:` | Regex marking where speaker notes begin (matches `note:` and `notes:`) |
| `data-charset` | | Charset of the external file |

Use `\r?\n` instead of `\n` so the regex works with Windows line endings.

## Element attributes

HTML comment after the element:

```markdown
- Item 1 <!-- .element: class="fragment" data-fragment-index="2" -->
- Item 2 <!-- .element: class="fragment" data-fragment-index="1" -->
```

## Slide attributes

```markdown
<!-- .slide: data-background="#ff0000" -->
Markdown content
```

Any `<section>` attribute works (`data-background-*`, `data-transition`, `data-auto-animate`, `data-visibility`, ...).

## Code blocks with line highlights

````markdown
```js [1-2|3|4]
let a = 1;
let b = 2;
let c = x => 1 + 2 + x;
c(3);
```
````

Steps are `|`-separated inside `[...]`. Line-number offset: ```` ```js [712: 1-2|3|4] ````. See `code.md`.

## Speaker notes

```markdown
## Title
Content

Note:
Only shown in the speaker view.
```

## Math

Wrap in math delimiters, e.g. `$$ J(\theta) = \sum_i x_i $$`; needs the math plugin (see `math.md`).

## Configure marked

```js
Reveal.initialize({ markdown: { smartypants: true } }); // any marked option
```

## Gotchas

- Markdown slides can't use arbitrary nested layout (grids, cards) cleanly; for custom layout use plain HTML sections (they can be mixed in one deck).
- Fragments need the `.element:` comment, there is no Markdown-native syntax.
- Markdown slides get no `.content` wrapper, so their text starts right under the title (top-aligned) instead of being vertically centered. For a centered or gridded layout use an HTML `<section>`. Verified: with `assets/base-styles.css` the heading, fragments (`<!-- .element: class="fragment" -->`), stepped code (` ```js [1|2] `), `Note:` speaker notes and inline `$...$` math all render.
