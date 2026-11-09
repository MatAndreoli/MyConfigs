# Lightbox (5.2.0+)

Docs: lightbox. A full-screen overlay for an image, video or web page, opened by clicking an element. Good for thumbnails on dense slides.

```html
<!-- image: opens its own src -->
<img src="reveal.png" data-preview-image />
<!-- image: opens a different image -->
<img src="thumb.png" data-preview-image="full.svg" />

<!-- video -->
<video src="video.mp4" data-preview-video></video>
<img src="poster.png" data-preview-video="video.mp4" />

<!-- iframe -->
<a href="https://example.com" data-preview-link>Open site</a>
<img src="shot.png" data-preview-link="https://example.com" />
```

Works on any element (buttons, links):

```html
<a data-preview-image="image.png">Open logo</a>
<button data-preview-video="video.mp4">Open video</button>
```

## Fit mode: `data-preview-fit`

| Value | Effect |
|---|---|
| `scale-down` (default) | Shrink to fit if needed |
| `contain` | Scale up or down to fit, no cropping |
| `cover` | Fill the lightbox, may crop |

```html
<img src="reveal.png" data-preview-image data-preview-fit="cover" />
```

## Notes

- `data-preview-link` only works if the target allows embedding; many sites send `X-Frame-Options`/CSP that block it.
- Global switch: `previewLinks: true` opens every link in an iframe lightbox; per link use `data-preview-link="false"` to opt out.
- Verified: clicking an `<img data-preview-image>` opens `.r-overlay.r-overlay-preview` (Esc closes). It is a click action, so a slide screenshot never shows it open.
