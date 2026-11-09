# Layout helper classes

Docs: layout. Built-in helpers; they need no custom CSS. For deck size/scaling see `presentation-size.md`.

## `r-stack`: layer elements in the same spot

Centers children on top of each other; pair with fragments.

```html
<div class="r-stack">
  <img class="fragment" src="a.png" width="450" height="300" />
  <img class="fragment" src="b.png" width="300" height="450" />
  <img class="fragment" src="c.png" width="400" height="400" />
</div>
```

Show each one alone (replace, don't pile up):

```html
<div class="r-stack">
  <img class="fragment fade-out" data-fragment-index="0" src="a.png" />
  <img class="fragment current-visible" data-fragment-index="0" src="b.png" />
  <img class="fragment" src="c.png" />
</div>
```

## `r-fit-text`: biggest text that fits

```html
<h2 class="r-fit-text">BIG</h2>
<h2 class="r-fit-text">CAN BE USED FOR MULTIPLE HEADLINES</h2>
```

Uses fitty. Good for single-line statement or title slides; not for paragraphs.

## `r-stretch`: fill remaining height

Resizes an img/video to the slide height minus its siblings.

```html
<h2>Stretch Example</h2>
<img class="r-stretch" src="image.svg" />
<p>Image byline</p>
```

Limits: only a **direct child** of the `<section>`, and only **one** per slide.

## `r-hstack` / `r-vstack`: flex rows and columns

Present in reveal.css 6.0.2. `r-hstack` is a horizontal flex row, `r-vstack` a vertical column; both center their children on both axes and make `img`/`video` children `object-fit: contain`. Modifier classes (same stylesheet): `items-start|center|end|stretch` (cross axis) and `justify-start|center|end|between|around` (main axis).

```html
<div class="r-hstack justify-around items-center">
  <img src="a.svg" width="160"><img src="b.svg" width="160"><img src="c.svg" width="160">
</div>
<div class="r-vstack"><h3>Title</h3><img src="a.svg" width="240"></div>
```

For text cards and grids prefer the skill's `.cols-*` classes (`slide-layouts.md`); use these for image/media rows. Combine with `r-stretch` to fill the remaining height.

## `r-frame`: bordered emphasis

```html
<img class="r-frame" src="logo.svg" width="200" />
<a href="#"><img class="r-frame" src="logo.svg" width="200" /></a> <!-- hover effect when inside an anchor -->
```

## Columns, cards, grids

reveal.js has no grid helper: use plain CSS (`display: grid` / flex) on a `div` inside the section. Slides are inside a scaled box, so use fixed units (`px`/`pt`) relative to the deck's configured size (reveal.js defaults to 960×700; the starter stylesheet in `design.md` assumes 1280×720; see `presentation-size.md`), and check the result at that size.
