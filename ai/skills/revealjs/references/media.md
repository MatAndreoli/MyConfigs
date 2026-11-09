# Media: autoplay, lazy loading, iframes

Docs: media. Applies to `<video>`, `<audio>`, `<iframe>`.

## Autoplay

```html
<video data-autoplay src="clip.mp4"></video>
```

Global override: `autoPlayMedia: true` (all play), `false` (none play), `null` (default: only `data-autoplay`).

Media and YouTube/Vimeo iframes are paused when you leave the slide; add `data-ignore` to opt out.

## Lazy loading

Swap `src` for `data-src`; only slides within `viewDistance` (default 3) load. Works for img, video, audio, iframe.

```html
<section>
  <img data-src="image.png" />
  <iframe data-src="https://example.com"></iframe>
  <video>
    <source data-src="video.webm" type="video/webm" />
    <source data-src="video.mp4" type="video/mp4" />
  </video>
</section>
```

Lazy video/audio won't start until the slide is visible.

### Lazy iframes

- Ignore `viewDistance`: load only when their slide becomes visible, unload when hidden (an iframe could otherwise play sound off-screen).
- `data-preload` on the iframe: load by `viewDistance` instead.
- `preloadIframes: true|false|null` overrides globally (`true` = all `data-src` iframes preload by distance, `false` = only when visible).

## Iframes in general

reveal.js auto-detects YouTube and Vimeo embed URLs and autoplays them when the slide shows. An iframe inside a slide is limited to the slide box; for full-page use an iframe background (`backgrounds.md`).

### postMessage to iframes

reveal.js posts `slide:start` and `slide:stop` to embedded iframes:

```js
// inside the iframe
window.addEventListener('message', (e) => {
  if (e.data === 'slide:start') { /* slide visible */ }
  else if (e.data === 'slide:stop') { /* hidden */ }
});
```

`preventIframeAutoFocus: true` keeps iframes from stealing keyboard focus. It is **off unless you set it** (reveal.js 6.0.2 has no default for it).

## Lightbox from media

`data-preview-image` / `data-preview-video` / `data-preview-link` on any element opens a full-screen overlay; see `lightbox.md`.
