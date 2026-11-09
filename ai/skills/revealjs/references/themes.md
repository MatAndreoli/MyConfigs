# Themes and custom styling

Docs: themes; theme variables from `css/theme/template/settings.scss` (6.0.2).

## Built-in themes

`black` (default), `white`, `league`, `beige`, `night`, `serif`, `simple`, `solarized`, `moon`, `dracula`, `sky`, `blood`. `dist/theme/` also ships `black-contrast.css` and `white-contrast.css`.

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.2/dist/theme/black.css" />
```

Swap the filename to change theme. Load your own stylesheet **after** the theme.

## Custom properties (override on `:root`)

| Variable | Controls |
|---|---|
| `--r-background-color` | Page/deck background |
| `--r-main-font`, `--r-main-font-size`, `--r-main-color` | Body text |
| `--r-block-margin` | Vertical spacing between text blocks |
| `--r-heading-font`, `--r-heading-color`, `--r-heading-margin`, `--r-heading-line-height`, `--r-heading-letter-spacing`, `--r-heading-text-transform`, `--r-heading-text-shadow`, `--r-heading-font-weight` | Headings |
| `--r-heading1-size` … `--r-heading4-size` | h1-h4 sizes (themes use `em`, e.g. 3.77em) |
| `--r-code-font` | Code font |
| `--r-link-color`, `--r-link-color-dark`, `--r-link-color-hover` | Links |
| `--r-selection-background-color`, `--r-selection-color` | Text selection |
| `--r-overlay-element-bg-color`, `--r-overlay-element-fg-color` | Controls/progress UI (as `r, g, b` triplets) |

```css
:root {
  --r-background-color: #0b1020;
  --r-main-font: "Inter", Helvetica, sans-serif;
  --r-main-color: #e6e9f2;
  --r-heading-font: "Inter", Helvetica, sans-serif;
  --r-heading-text-transform: none;   /* many themes uppercase headings */
  --r-link-color: #ff6b3d;
}
```

Fonts: add a Google Fonts `@import`/`<link>` before the stylesheet that uses them.

## Styling tips

- Scope custom CSS under `.reveal` (e.g. `.reveal .slides section .card {}`), and target `.reveal h2` etc. to beat theme specificity.
- Per-slide styling: add a class on the `<section>` or use `data-state` (see `setup.md`).
- Per-slide background: see `backgrounds.md`.
- Slide text alignment is centered in most themes; set `.reveal .slides section { text-align: left; }` for left-aligned decks.
- Pair with `center: false` for top-aligned layouts (see `presentation-size.md`).

## Authoring a theme (needs the full setup)

Duplicate a `css/theme/*.scss`; it includes `template/mixins.scss`, `template/settings.scss` (variables), `template/theme.scss`, then your fonts/overrides. `npm run build:styles` compiles to CSS. For a one-off deck, overriding custom properties in a plain CSS file is simpler; a blank CSS document is also valid.
