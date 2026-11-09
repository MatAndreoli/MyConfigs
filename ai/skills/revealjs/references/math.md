# Math

Docs: math. LaTeX typesetting via the math plugin; choose KaTeX (recommended) or MathJax 2/3/4.

```html
<script src=".../dist/plugin/math.js"></script>
<script>Reveal.initialize({ plugins: [RevealMath.KaTeX] });</script>
```

```html
<section>
  <h2>The Lorenz Equations</h2>
  \[\begin{aligned} \dot{x} &amp; = \sigma(y-x) \\ \dot{y} &amp; = \rho x - y - xz \end{aligned} \]
</section>
```

Escape `&` as `&amp;` in HTML.

| Library | Plugin | Config key |
|---|---|---|
| KaTeX | `RevealMath.KaTeX` | `katex` |
| MathJax 2 | `RevealMath.MathJax2` | `mathjax2` |
| MathJax 3 (4.2+) | `RevealMath.MathJax3` | `mathjax3` |
| MathJax 4 (6.0+) | `RevealMath.MathJax4` | `mathjax4` |

Default delimiters (KaTeX): `$$…$$` display, `$…$` inline, `\(…\)` inline, `\[…\]` display. Ignored tags: script, noscript, style, textarea, pre, code.

## KaTeX options

```js
Reveal.initialize({
  katex: {
    version: 'latest',              // pin, e.g. '0.13.18'
    delimiters: [
      { left: '$$', right: '$$', display: true },
      { left: '$', right: '$', display: false },
      { left: '\\(', right: '\\)', display: false },
      { left: '\\[', right: '\\]', display: true },
    ],
    ignoredTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
    local: 'node_modules/katex',    // offline; ignores `version`
  },
  plugins: [RevealMath.KaTeX],
});
```

Loads from `https://cdn.jsdelivr.net/npm/katex` unless `local` is set. Omit the `katex` key entirely if defaults are fine.

## MathJax

```js
Reveal.initialize({
  mathjax3: {
    mathjax: 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js', // pin a version; a smaller build like tex-svg is lighter
    tex: { inlineMath: [['$', '$'], ['\\(', '\\)']] },
    options: { skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'] },
  },
  plugins: [RevealMath.MathJax3],
});
```

- MathJax 2: `mathjax2: { mathjax: '.../mathjax@2/MathJax.js', config: 'TeX-AMS_HTML-full', tex2jax: { inlineMath, skipTags } }`.
- MathJax 4: `mathjax4: { mathjax: 'https://cdn.jsdelivr.net/npm/mathjax@4/tex-mml-chtml.js', tex, options }`.
- Offline: download the lib and point `mathjax` at the local copy.

## Markdown

```html
<section data-markdown>$$ J(\theta_0,\theta_1) = \sum_{i=0} $$</section>
```

## Gotchas

- Math in the `slidechanged` flow: some libs (MathJax) misrender under slide transforms; call their render/update inside a `slidechanged` handler (see `events.md`).
- Needs network for the default CDN loading; use `local`/local MathJax for offline decks.
- Verified with KaTeX in reveal.js 6.0.2: `$$...$$` display, `$...$` inline, in HTML and in markdown slides. The starter stylesheet enlarges display equations (`.katex-display > .katex`); `check-deck.py` ignores KaTeX's small superscript text.
