# Design: themes, palettes, typography, density

How to make a deck look designed instead of default. Use with `assets/base-styles.css` (starter stylesheet) and `slide-layouts.md` (slide patterns). Reveal's own theme mechanics are in `themes.md`.

## Before writing any slide

State the design approach in a few lines to the user: subject and audience, tone, palette (name + 5 hex tokens), font pairing, canvas size. Decide from the content, not by default:

- **Subject and tone**: a security review is sober and high-contrast; a product launch can be warm and bold; a data readout is quiet so the numbers carry it.
- **Branding**: if a company or product is named, start from its colors and typeface and adapt them to the tokens below.
- **Audience and room**: projected in a bright room → light background or very high contrast; shared as a link/PDF → either.
- Avoid the autopilot choice (navy for finance, green for health). Pick one dominant color, one accent used sparingly, neutral surfaces.

## Setup that the starter stylesheet assumes

```html
<html lang="en" data-palette="midnight">
...
<link rel="stylesheet" href=".../dist/reset.css" />
<link rel="stylesheet" href=".../dist/reveal.css" />
<link rel="stylesheet" href=".../dist/theme/black.css" />   <!-- any theme; the stylesheet overrides it -->
<link rel="stylesheet" href="styles.css" />                 <!-- copy of assets/base-styles.css, loaded LAST -->
...
Reveal.initialize({ width: 1280, height: 720, center: false, display: 'flex', margin: 0.04, hash: true });
```

- Copy `assets/base-styles.css` next to the deck as `styles.css`, then edit tokens in `:root` (colors, fonts) instead of rewriting rules.
- `display: 'flex'` is required: every slide is a full-height flex column.
- `center: false` keeps titles on a fixed line across slides (`presentation-size.md`).
- 1280×720 is 16:9. The whole canvas scales, so px values stay proportional on any screen.

## Tokens

| Token | Role |
|---|---|
| `--bg` | Page background |
| `--surface` | Cards, panels, table zebra (a step lighter/darker than `--bg`) |
| `--text` | Body and headings |
| `--muted` | Secondary text, labels, captions |
| `--primary` | Bullets, `<strong>`, links, bars, step numbers |
| `--accent` | One highlight: eyebrow, quote bar, a key number. Use sparingly |
| `--font-body`, `--font-head` | Font stacks |

Edit these in `:root`, or pick a ready palette with `data-palette`.

## Palettes (contrast checked)

Every pair below was measured (all use the dark code panel, which stays light-on-dark in every palette): text/background ≥ 10:1, muted ≥ 5.5:1, primary and accent ≥ 4.7:1 on `--bg` (WCAG AA for normal text is 4.5:1).

| `data-palette` | Mood | bg | surface | text | muted | primary | accent |
|---|---|---|---|---|---|---|---|
| `midnight` (default) | Tech, engineering, product | `#0f1226` | `#1a1f3d` | `#eef0ff` | `#a3a9cc` | `#7c8cff` | `#ffb454` |
| `graphite` | Neutral, serious, incident/security | `#1c1d20` | `#27292e` | `#f1f1f3` | `#a1a3aa` | `#ff5a4d` | `#4dd2c6` |
| `ocean` | Calm, data, infrastructure | `#06283d` | `#0b3a57` | `#e8f4fa` | `#9cc3d9` | `#47b5ff` | `#ffd166` |
| `forest` | Sustainability, growth, finance | `#10231c` | `#183328` | `#eaf3ee` | `#9bb8a9` | `#5ed39a` | `#f2c14e` |
| `plum` | Creative, brand, community | `#2a1633` | `#3a2048` | `#f6eefa` | `#c3a8d1` | `#ff7eb6` | `#8be9c1` |
| `paper` | Editorial, workshops, printed handouts | `#faf7f2` | `#ffffff` | `#1f2430` | `#5b6272` | `#c2410c` | `#0f766e` |
| `ink` | Clean corporate, projector in bright rooms | `#ffffff` | `#f3f4f6` | `#111827` | `#4b5563` | `#2563eb` | `#e11d48` |
| `sand` | Warm, human, research | `#f3ebdd` | `#fbf6ec` | `#2b2a26` | `#625d52` | `#9a3412` | `#365314` |

A custom palette: set the six tokens, then **check contrast** (text vs bg, muted vs bg and vs surface, primary vs bg). Brand colors often fail on dark or light backgrounds; darken/lighten the brand color for text uses and keep the exact brand color for fills.

## Typography

- Heading font + body font, two families at most. Web-safe is fine (Helvetica/Arial/Georgia); for personality use Google Fonts (`@import` at the top of `styles.css`, or `<link>` in the head). Google Fonts needs network: keep a web-safe fallback in the font stack (the stylesheet does), and for an offline deck download the font files and use `@font-face`.
- Pairings that work: Space Grotesk + Inter (tech), Playfair Display + Source Sans 3 (editorial), DM Serif Display + DM Sans (warm), IBM Plex Sans + IBM Plex Mono (engineering), Poppins + Inter (friendly).
- Scale on the 1280×720 canvas (already in the stylesheet): h1 64-72, h2 44, h3 28-30, lead 30, body 24, card text 22, small/caption 16-18. **Running text (paragraphs, bullets, card and step descriptions) never below 20**; short labels (stat labels, table headers, node subtitles, footnotes, slide number) may go down to 16-18, nothing smaller.
- Headings sentence case, `text-transform: none` (reveal themes uppercase by default; the stylesheet turns it off).
- Left-align body text. Title, divider and quote slides are left-aligned and vertically centered by default; add `class="center"` on the `<section>` for a centered variant (`text-align` only; do not center bullet lists).
- Mono font for code: `--r-code-font`.

## Hierarchy and consistency

- One idea per slide, stated as the heading ("Rollbacks are one command" beats "Rollbacks").
- Same title position, same margins, same card style across the deck. Repeat patterns; vary only the layout type (see `slide-layouts.md`).
- Color carries meaning: primary = emphasis, accent = the one thing to look at, muted = supporting. Don't recolor per slide.
- Emphasis with `<strong>` (colored `--primary`), not ALL CAPS or underlines.

## Density

| Slide type | Limit |
|---|---|
| Bullet slide | ≤ 5 bullets, ≤ 12 words each |
| Cards | 3 (or 4 small) per row, ≤ 20 words each |
| Stats | 3-4 numbers; value ≤ 6 characters |
| Table | ≤ 6 rows × 4 columns |
| Code | ≤ 12 lines; highlight steps for more |

**Light slide → make it bigger, don't leave a small cluster floating.** Use `.lead` (30px) for text, `table.big`, fewer/larger cards, or a stat/quote layout. Dense slide → `<div class="content top">` so it starts under the title instead of being centered, and split the slide if it still doesn't fit (slides don't scroll; see `presentation-size.md`).

## Variety (avoid a deck of identical bullet slides)

Don't use the same layout on consecutive slides. Rotate: bullets + callout, cards, stats, steps, comparison table, quote, code + explanation, full-bleed image. Break long lists into two columns or cards. A section divider every 3-5 slides gives rhythm.

## Images, icons and backgrounds

- Photos: use as `data-background-image` with a dark `data-background-color` and `data-background-opacity` 0.4-0.6, or `.media-fill` inside a column. Add `class="on-image"` to the slide for white text (`slide-layouts.md`, `backgrounds.md`).
- Icons: inline SVG or emoji need no network; Font Awesome via cdnjs works (pin version; add SRI). Put the icon in `.card .icon`.
- Never stretch images; use `object-fit: cover` (`.media-fill`) with a fixed-height container.
- Charts and diagrams: see `charts-and-graphics.md` (CSS bars, inline SVG, Chart.js only if needed, interactive controls); they read the palette tokens so they match the deck.

## Accessibility

- Contrast ≥ 4.5:1 for text (≥ 3:1 for large/bold), including text on `--surface` and on background images.
- Don't rely on color alone for meaning; pair with an icon, label or position.
- `alt` on images; `lang` on `<html>`.

## Checks before delivering

1. Run `python3 ~/.claude/skills/revealjs/scripts/check-deck.py deck.html [--out DIR] [--size 1920x1080] [--settle 1.5]`. It serves the deck folder over http (so external Markdown and iframes work), drives one headless Chrome in real time and writes one PNG per slide (`s<h>-<v>.png`, nothing built) plus `s<h>-<v>-step<i>.png` for every fragment and code-highlight step. It waits `--settle` seconds before each shot so entrance animations have finished. At each slide's fully built state it reports: overflow, `outside-slide` (an element sticking out of the slide, e.g. centered content spilling over the title), text under 16px (SVG and KaTeX excluded), contrast below 4.5:1 (3:1 for large text; skipped over image, video, iframe and gradient backgrounds), empty slides, and any file the deck requests that returns 4xx/5xx (e.g. a missing external `.md`). Page exceptions are listed as warnings. Exit code 1 if anything failed. About 1-2 s per screenshot (a 100-slide deck took ~2 min at `--settle 0.5`). Then look at each image (decktape also works: `npx decktape reveal deck.html out.pdf --screenshots`).
2. Look for: text outside the canvas or clipped, a heading wrapping to two lines that breaks alignment between cards, low-contrast text on custom backgrounds, empty-looking slides, missing fonts/icons (network).
3. Programmatic overflow hint after init: `Reveal.getSlides().filter(s => s.scrollHeight > s.clientHeight + 2)`.
4. Measuring layout in script: `getBoundingClientRect()` is multiplied by the deck's fit-to-window scale (`Reveal.getScale()`), so values mislead on any window that isn't exactly 1280×720. Use `offsetTop`/`offsetHeight`/`scrollHeight` (unscaled), or divide rects by `Reveal.getScale()`. Screenshots at `--window-size=1280,720` have scale ≈ 1.
5. Step through states, not just slides: screenshot `#/<h>/<v>/<f>` for stepped code highlights and fragments. `<f>` is the zero-based last visible step (`-1` none, `0` first step, `99` fully built); the plain `#/<h>` URL shows none of them (`fragments.md`).
6. Speaker notes: put `<aside class="notes">` on every content slide that you will present (talk track, numbers behind the chart, likely questions). Needs the notes plugin (`speaker-view.md`).

## Delivering the design choices

Say the design approach (palette, fonts, canvas, layout pattern per slide) to the user before building when you can talk to them. When you are running unattended (no user to answer), put it at the top of your final report instead.
