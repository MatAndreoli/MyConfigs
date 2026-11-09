# Navigation controls: keyboard, touch, overview, fullscreen, pause, help

Docs: keyboard, touch-navigation, overview, fullscreen, config.

## Default keys

| Key | Action |
|---|---|
| ← → ↑ ↓ / space | Navigate (see `navigationMode` in `vertical-slides.md`) |
| **N** / **P**, **H J K L** | Next / previous; vim-style left, down, up, right |
| **Alt** + arrow | Navigate without stepping fragments |
| **Shift** + arrow | Jump to first/last slide |
| **S** | Speaker view (needs notes plugin) |
| **F** | Fullscreen (**Esc** exits) |
| **O** / **Esc** | Overview mode |
| **G** | Jump to slide (see `links.md`) |
| **A** | Pause/resume auto-slide |
| **B** / **.** | Pause (blackout) when `pause: true` |
| **?** | Help overlay when `help: true` |
| **Ctrl+Shift+F** | Search (search plugin) |
| **Alt+click** (Ctrl+click on Linux) | Zoom into an element (zoom plugin) |

## Custom key bindings

```js
Reveal.configure({
  keyboard: {
    27: () => console.log('esc'),   // function
    13: 'next',                     // API method name
    32: null,                       // disable
  },
});
```

Runtime: `Reveal.addKeyBinding({ keyCode: 84, key: 'T', description: 'Start timer' }, fn)`; `Reveal.removeKeyBinding(keyCode)`. These appear in the help overlay; a bare keycode (`addKeyBinding(82, fn)`) doesn't. `keyboard: false` disables shortcuts; `keyboardCondition: 'focused'` captures keys only for the focused (embedded) deck.

## Touch

Swipe navigates on touch devices. Disable with `touch: false`. Protect scrollable/interactive regions:

```html
<p data-prevent-swipe>Swiping across this does not change slides.</p>
```

## Overview (bird's-eye)

`overview: true` by default. `Reveal.toggleOverview(true|false)`, events `overviewshown`/`overviewhidden`.

## Fullscreen

Built in (**F**); no config. Embedded decks need focus first.

## Misc config

`controls`, `controlsLayout: 'bottom-right' | 'edges'`, `controlsBackArrows: 'faded' | 'hidden' | 'visible'`, `controlsTutorial`, `progress`, `mouseWheel`, `hideInactiveCursor`/`hideCursorTime`, `loop`, `rtl`, `shuffle`. Full list: `config.md`.
