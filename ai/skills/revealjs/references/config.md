# Configuration options

Docs: config. Every option is optional. Pass to `Reveal.initialize({...})`; change later with `Reveal.configure({...})`. Defaults shown.

## UI

| Option | Default | Notes |
|---|---|---|
| `controls` | `true` | `false`, or `'speaker'` (speaker view only) |
| `controlsTutorial` | `true` | Hints (bouncing arrow) |
| `controlsLayout` | `'bottom-right'` | or `'edges'` |
| `controlsBackArrows` | `'faded'` | `'hidden'`, `'visible'` |
| `progress` | `true` | Progress bar |
| `slideNumber` | `false` | `true`, format string, or function (`slide-numbers.md`) |
| `showSlideNumber` | `'all'` | `'print'`, `'speaker'` |
| `help` | `true` | `?` overlay |
| `pause` | `true` | Blackout key |
| `hideInactiveCursor` / `hideCursorTime` | `true` / `5000` | |
| `showNotes` | `false` | `true`, `'separate-page'` (`speaker-view.md`) |

## Navigation

| Option | Default | Notes |
|---|---|---|
| `hash` | `false` | Slide in URL |
| `hashOneBasedIndex` | `false` | 1-based `#/` links |
| `respondToHashChanges` | `true` | |
| `history` | `false` | Push each slide to history; implies `hash` |
| `jumpToSlide` | `true` | **G** shortcut |
| `keyboard` | `true` | Or a key map (`navigation-controls.md`) |
| `keyboardCondition` | `null` | `'focused'` or function |
| `touch` | `true` | |
| `mouseWheel` | `false` | |
| `overview` | `true` | |
| `loop` | `false` | |
| `rtl` | `false` | |
| `navigationMode` | `'default'` | `'linear'`, `'grid'` |
| `shuffle` | `false` | Random slide order per load |
| `fragments` | `true` | Global fragment switch |
| `fragmentInURL` | `true` | |

## Layout

| Option | Default | Notes |
|---|---|---|
| `width` / `height` | `960` / `700` | `presentation-size.md` |
| `margin` | `0.04` | |
| `minScale` / `maxScale` | `0.2` / `2.0` | |
| `center` | `true` | Vertical centering |
| `embedded` | `false` | |
| `disableLayout` | `false` | |
| `display` | `'block'` | CSS display for slides (e.g. `'flex'`) |
| `view` / `scroll*` | | `scroll-view.md` |

## Animation and media

| Option | Default | Notes |
|---|---|---|
| `transition` | `'slide'` | `none/fade/slide/convex/concave/zoom` |
| `transitionSpeed` | `'default'` | `fast`, `slow` |
| `backgroundTransition` | `'fade'` | |
| `autoAnimate`, `autoAnimateMatcher`, `autoAnimateEasing` (`'ease'`), `autoAnimateDuration` (`1.0`), `autoAnimateUnmatched` (`true`), `autoAnimateStyles` | | `auto-animate.md` |
| `autoSlide` | `0` | `auto-slide.md` |
| `autoSlideStoppable` | `true` | |
| `autoSlideMethod` | `null` | |
| `autoPlayMedia` | `null` | `media.md` |
| `preloadIframes` | `null` | |
| `preventIframeAutoFocus` | none (off) | Set `true` to stop iframes grabbing keyboard focus; reveal.js 6.0.2 has no default for it, it just checks the value |
| `viewDistance` | `3` | Slides loaded around current |
| `mobileViewDistance` | `2` | |
| `previewLinks` | `false` | Open links in iframe lightbox (`lightbox.md`) |
| `parallaxBackground*` | | `backgrounds.md` |

## Speaker / export / integration

| Option | Default | Notes |
|---|---|---|
| `defaultTiming` | `null` | Seconds per slide for pacing (`totalTime` also supported) |
| `pdfMaxPagesPerSlide` | unlimited | `pdf-export.md` |
| `pdfSeparateFragments` | `true` | |
| `pdfPageHeightOffset` | `-1` | |
| `postMessage` | `true` | `postmessage.md` |
| `postMessageEvents` | `false` | |
| `focusBodyOnPageVisibilityChange` | `true` | Keeps shortcuts working after tab switch |
| `plugins` | `[]` | `plugins.md` |
| `markdown`, `highlight`, `katex`, `mathjax2/3/4` | | plugin-specific |

## Reconfigure

```js
Reveal.configure({ autoSlide: 0 });
Reveal.configure({ autoSlide: 5000 });
Reveal.getConfig();
```
