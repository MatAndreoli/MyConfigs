---
name: revealjs
description: Use when asked to create, edit or debug a reveal.js presentation, slide deck or slideshow as HTML, including fragments, auto-animate, backgrounds, code or math slides, speaker notes, PDF export, themes, or embedding reveal.js in a page or React app.
---

# reveal.js presentations

Reference skill for building decks with reveal.js (docs revealjs.com, verified against **6.0.2**). This file is the map; each feature has its own file in `references/`. Read the reference for a feature **before** using it, instead of guessing attribute names.

## Workflow

1. **Plan**: slide list, one message per slide, which are section dividers, where a vertical stack helps (`references/vertical-slides.md`). Choose a layout pattern per slide from `references/slide-layouts.md`, varying neighbors.
2. **Design first**: read `references/design.md`, then tell the user your approach (subject/tone, palette, fonts, 1280×720 canvas) **before writing slides**. Base the choice on the content and any branding mentioned.
3. **Scaffold**: copy `assets/template.html` as the deck (CDN, pinned version, plugins and init already wired; no build step) and `assets/base-styles.css` next to it as `styles.css`; `references/setup.md` explains each part. The template already loads `styles.css` after the theme and initializes with `{ width: 1280, height: 720, center: false, display: 'flex' }`; set the title, pick a `data-palette` or edit the tokens, replace the sample slides.
4. **Fill slides** one or a few at a time with Edit, not one giant rewrite. Use the snippets in `references/slide-layouts.md`; give every `<section>` a unique `id`.
5. **Verify**: run `python3 ~/.claude/skills/revealjs/scripts/check-deck.py deck.html` (needs headless Chrome). It serves the deck over http, screenshots every slide and every fragment/code-highlight step in real time into `shots/`, and prints overflow, elements sticking out of the slide, text under 16px, low-contrast text and failed file loads. Fix what it reports, then view **each** screenshot: it cannot see wrapped headings, near-empty slides, missing icons/fonts or text over images (checklist in `design.md`).
6. Tell the user how to open it (serve it if it uses external Markdown or the speaker view).

## Feature index

| Need                                                                  | Read                                |
| --------------------------------------------------------------------- | ----------------------------------- |
| **Look and feel**: palette, fonts, type scale, density, accessibility | `references/design.md` + `assets/base-styles.css` |
| **Slide layouts**: title, divider, bullets, cards, stats, steps, flow, quote, table, code, image | `references/slide-layouts.md` |
| **Charts, diagrams, interactive controls**: CSS bars, inline SVG (default), Chart.js (only if needed), calculators | `references/charts-and-graphics.md` |
| **Stacked (vertical) slides**: when and how to use them in a deck | `references/vertical-slides.md` |
| HTML skeleton, CDN files, install, init, multiple decks, slide states | `references/setup.md`               |
| Vertical stacks, `navigationMode`                                     | `references/vertical-slides.md`     |
| Write slides in Markdown, external `.md`, element/slide attributes    | `references/markdown.md`            |
| Color, gradient, image, video, iframe, parallax backgrounds           | `references/backgrounds.md`         |
| Step-by-step reveal of elements                                       | `references/fragments.md`           |
| Animate matching elements between two slides                          | `references/auto-animate.md`        |
| Slide-to-slide transitions                                            | `references/transitions.md`         |
| Syntax-highlighted code, line highlights                              | `references/code.md`                |
| LaTeX equations                                                       | `references/math.md`                |
| Built-in helpers `r-stack`, `r-fit-text`, `r-stretch`, `r-frame`      | `references/layout.md`              |
| Deck size, scaling, centering, embedding                              | `references/presentation-size.md`   |
| Themes, CSS custom properties, fonts                                  | `references/themes.md`              |
| Video/audio/iframe autoplay and lazy loading                          | `references/media.md`               |
| Click-to-enlarge image/video/page overlay                             | `references/lightbox.md`            |
| Speaker notes, timers, speaker window                                 | `references/speaker-view.md`        |
| PDF / print export                                                    | `references/pdf-export.md`          |
| Scrollable page view                                                  | `references/scroll-view.md`         |
| Internal links, nav buttons, URL hash, jump-to-slide                  | `references/links.md`               |
| Slide numbers and progress                                            | `references/slide-numbers.md`       |
| Hidden / uncounted (appendix) slides                                  | `references/slide-visibility.md`    |
| Self-running / kiosk decks                                            | `references/auto-slide.md`          |
| Keyboard, touch, overview, fullscreen, controls                       | `references/navigation-controls.md` |
| Every config option and default                                       | `references/config.md`              |
| `Reveal.*` methods, get/set state                                     | `references/api.md`                 |
| Event hooks                                                           | `references/events.md`              |
| Built-in and custom plugins                                           | `references/plugins.md`             |
| Control a deck from another window                                    | `references/postmessage.md`         |
| React (`@revealjs/react`)                                             | `references/react.md`               |

## Rules that prevent common failures

- Structure is exactly `.reveal > .slides > section`; nested `section`s are a vertical stack.
- Load order: `reveal.js` first, then plugin scripts, then `Reveal.initialize({ plugins: [...] })`. A plugin script that is not listed in `plugins` does nothing.
- `file://` is fine for plain decks; external Markdown and the speaker view need a web server.
- Slides do not scroll: content taller than the canvas overflows. Cut content or split the slide; do not shrink text below legibility.
- Fragments and auto-animate need correct adjacency/markup (`data-auto-animate` on two **adjacent** sections; `data-id` to force a match).
- Override theme styling with CSS loaded **after** the theme, scoped under `.reveal`. With `assets/base-styles.css`, change tokens, not rules.
- Contrast is not automatic: text on custom backgrounds or images must be checked (`design.md`).
- A light slide with small text looks empty: scale it up (`.lead`, `table.big`, fewer larger cards) instead of leaving a small cluster.
- Pin the reveal.js version in CDN URLs. Add `integrity` (SRI) and `crossorigin="anonymous"` to the CDN tags (required for shared decks, and some security hooks insist on it), or vendor the files locally.
- For anything the docs cover but is not listed here (e.g. upgrading from 3.x/4.x), see <https://revealjs.com/upgrading/>.
