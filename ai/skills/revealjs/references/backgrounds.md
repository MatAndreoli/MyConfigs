# Slide backgrounds

Docs: backgrounds. Slides sit in a scaled box; backgrounds paint the full page behind them. Set on a `<section>`. Four types: color, gradient, image, video, iframe.

## Color

Any CSS color (hex, keyword, `rgba()`, `hsl()`).

```html
<section data-background-color="aquamarine">...</section>
<section data-background-color="rgb(70, 70, 255)">...</section>
```

## Gradient

Any CSS gradient: `linear-gradient`, `radial-gradient`, `conic-gradient`.

```html
<section data-background-gradient="linear-gradient(to bottom, #283b95, #17b2c3)">...</section>
```

## Image

| Attribute | Default | Notes |
|---|---|---|
| `data-background-image` | | URL. GIFs restart when the slide opens |
| `data-background-size` | `cover` | CSS `background-size` |
| `data-background-position` | `center` | CSS `background-position` |
| `data-background-repeat` | `no-repeat` | CSS `background-repeat` |
| `data-background-opacity` | `1` | 0-1; lower it to keep text legible over a photo |

```html
<section data-background-image="img.png" data-background-size="100px" data-background-repeat="repeat">
```

## Video

| Attribute | Default | Notes |
|---|---|---|
| `data-background-video` | | One source or comma-separated list |
| `data-background-video-loop` | false | |
| `data-background-video-muted` | false | |
| `data-background-size` | `cover` | `contain` letterboxes |
| `data-background-opacity` | `1` | |

```html
<section data-background-video="clip.mp4" data-background-video-loop data-background-video-muted>
```

## Iframe

Covers 100% of the deck in the background layer; not interactive by default.

```html
<section data-background-iframe="https://example.com" data-background-interactive>
```

`data-background-interactive` makes the iframe clickable but blocks interaction with the slide content. Iframes lazy-load when visible; add `data-preload` on the section to preload, or set `preloadIframes` globally. Target site must allow embedding (`X-Frame-Options`/CSP).

## Background transition

Default is cross-fade. Global: `backgroundTransition: 'slide'`; per slide: `data-background-transition`. See `transitions.md`.

## Parallax

```js
Reveal.initialize({
  parallaxBackgroundImage: 'https://.../bg.jpg',
  parallaxBackgroundSize: '2100px 900px', // px only; no % or auto
  parallaxBackgroundHorizontal: 200,      // px moved per slide, optional (0 disables axis)
  parallaxBackgroundVertical: 50,
});
```

The image must be much larger than the screen.

## Agent notes

- Text contrast: a background change does not change the theme text color. Pick a theme/CSS color that stays readable, or use a slide-level `data-state` + CSS (see `setup.md`).
- Prefer solid/gradient backgrounds for offline decks; remote media needs network.
- In Markdown: `<!-- .slide: data-background="#ff0000" -->`.
