# Slide numbers

Docs: slide-numbers.

```js
Reveal.initialize({ slideNumber: true });      // default format "h.v"
Reveal.initialize({ slideNumber: 'c/t' });
```

| Value | Format |
|---|---|
| `h.v` | Horizontal.vertical (default) |
| `h/v` | Horizontal/vertical |
| `c` | Flattened count including vertical slides |
| `c/t` | Flattened count / total slides |

Custom: return an array.

```js
Reveal.initialize({
  slideNumber: (slide) => [Reveal.getIndices(slide).h], // ignore vertical numbering
});
```

(A function can return `[n]` or `[n1, delimiter, n2]`.)

## Where it shows: `showSlideNumber`

`'all'` (default), `'print'` (PDF only), `'speaker'` (speaker view only).

```js
Reveal.initialize({ slideNumber: true, showSlideNumber: 'print' });
```

## Related

- `progress: true` shows the progress bar.
- `data-visibility="uncounted"` excludes trailing slides from numbering and progress (see `slide-visibility.md`).
- `hashOneBasedIndex: true` makes `#/` links match visible slide numbers (see `links.md`).
