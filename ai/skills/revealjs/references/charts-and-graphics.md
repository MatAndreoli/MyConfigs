# Charts, diagrams and interactive elements

Every snippet here was rendered in headless Chrome with `assets/base-styles.css` (components: `.fig`, `.hbars`, `.chart-box`, `.legend`, `svg` classes, `.field`). Setup is in `design.md`.

## Pick a technique

| Need | Technique |
|---|---|
| 2-6 values compared (cost, share, score) | **CSS bars** (no library, animated) |
| Process, architecture, timeline, annotated figure | **Inline SVG** (+ fragments to build it step by step) |
| Line, area, scatter, a few dozen points, annotated crossings | **JS-built SVG** (vector, crisp at any size) |
| Bar with a few values, or a bar plus a target line | **Inline SVG** or **CSS bars** |
| Doughnut / pie of a few shares | **SVG donut** (below) |
| Many points, stacked series, zoom, built-in tooltips, data from a file | **Chart.js** (CDN), only when the above do not fit |
| "Try your own numbers" | **Interactive controls** |
| Comparison of many attributes | A `table` (`slide-layouts.md`), not a chart |

**Default to vector (CSS/SVG).** reveal.js scales the whole slide, and a Chart.js `<canvas>` is a bitmap that turns soft when scaled up (see the blur note in the Chart.js section). Reach for Chart.js only when you need what it gives for free.

One message per chart: the slide heading states the conclusion ("Cache 1h costs 12× less per hour"), the chart proves it. Label directly instead of relying on legends, ≤ 4 series, bars start at 0, no 3D, use palette tokens (`--primary`, `--accent`, `--muted`) so charts match the deck. Show the source/assumptions in a `.footnote`.

## CSS bars

```html
<section id="spend">
  <h2>Cache 1h costs 12× less per hour</h2>
  <div class="content">
    <div class="hbars">
      <div class="hbar"><p class="name">Cache 5m</p><div class="track"><div class="fill accent" style="--w:100%"></div></div><p class="val">$0.60/h</p></div>
      <div class="hbar"><p class="name">Cache 1h</p><div class="track"><div class="fill" style="--w:8%"></div></div><p class="val">$0.05/h</p></div>
    </div>
  </div>
</section>
```

- `--w` is the bar length as a % of the longest bar (compute it: `value / max * 100`).
- Bars grow when the slide becomes current because reveal.js puts the class `present` on it; the CSS keys on `section.present`. No JavaScript. They use CSS `animation` (keyframes), not `transition`, on purpose: a slide that is not showing is `display:none`, so a transition has no start state when you come back and the bars appear already full, while an animation restarts on every visit. Do the same for any entrance effect you add (key it on `section.present` with `animation`). Test by leaving the slide and returning; in headless Chrome use real time, not `--virtual-time-budget`, which freezes animation clocks.
- Up to 4 rows get staggered delays (the stylesheet); `.accent` highlights one bar.

## Inline SVG (diagrams, timelines, annotated figures)

```html
<figure class="fig">
  <div class="scroll" data-prevent-swipe>
    <svg viewBox="0 0 1160 260" role="img" aria-label="Without keepwarm the cache goes cold at 60 minutes. With keepwarm two pings keep it warm.">
      <g class="fragment" data-fragment-index="1">
        <text class="t" x="0" y="26">Without keepwarm</text>
        <rect class="f-primary" x="0" y="38" width="500" height="34"/><text class="on-fill" x="12" y="61">warm</text>
        <rect class="f-accent" x="500" y="38" width="560" height="34"/><text class="on-fill" x="512" y="61">cold</text>
      </g>
      <g class="fragment" data-fragment-index="2">
        <text class="t" x="0" y="130">With keepwarm</text>
        <rect class="f-primary" x="0" y="142" width="1060" height="34"/>
        <path class="link" d="M500 182 v14"/><text class="s" x="500" y="214" text-anchor="middle">ping</text>
      </g>
      <line class="axis" x1="0" x2="1060" y1="236" y2="236"/>
      <g class="tick"><text x="0" y="254">0</text><text x="1060" y="254" text-anchor="end">2h</text></g>
    </svg>
  </div>
  <figcaption>The same pause, two endings.</figcaption>
</figure>
```

Rules:
- **Author the `viewBox` at slide scale** (about 1160 wide inside the `.fig`), so `16px` text in SVG is about 16px on screen. A 760-wide viewBox scaled up makes text look oversized and inconsistent with the rest of the deck.
- Classes from the stylesheet: text `t` (label), `s` (small mono), `tick`, `on-fill` (text on a colored fill); shapes `node`, `axis`, `grid`, `link`, `f-primary`, `f-accent`, `f-muted`. Colors follow the palette and the dark/light switch automatically.
- Build a figure step by step with `class="fragment" data-fragment-index="n"` on `<g>` groups (several groups can share an index). Fragments work on SVG elements.
- Arrows: define a marker once, reuse it:
  `<defs><marker id="ah" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0L10 5L0 10z"/></marker></defs>` then `<line class="link" ... marker-end="url(#ah)"/>`. The stylesheet fills every `svg marker path` with `var(--text)`. **Do not rely on `currentColor` or a `color` set on the referencing element**: a marker inherits from where it is *defined* (`<defs>`), not where it is used (verified: an arrowhead stayed white inside a `<g color="var(--accent)">`), and `var()` does not work inside presentation attributes like `fill="var(--x)"`. For a different arrowhead color define a second marker and style it with CSS (`svg #ah-accent path { fill: var(--accent); }`).
- Draw-in line: `<path class="draw" pathLength="1" d="..." stroke="var(--primary)" fill="none" stroke-width="3"/>`; the stylesheet draws it when the slide becomes current.
- Always `role="img"` and an `aria-label` that states the takeaway.
- Wide figures: wrap in `.scroll` with `data-prevent-swipe` (touch scrolling will not change slides).
- For simple boxes-and-arrows prefer the HTML `.flow` component (`slide-layouts.md`): less to get wrong.

## SVG donut / pie

Vector, crisp at any scale, replays its sweep on every visit. Each share is a circle with `pathLength="100"`: `stroke-dasharray="<share-1> <rest>"` (the 1 leaves a thin gap) and `stroke-dashoffset="-<sum of the shares before it>"`. The group is rotated so the first segment starts at 12 o'clock. For a pie instead of a donut use `r="50"` with `style="stroke-width:100"`.

```html
<figure class="fig">
  <svg viewBox="0 0 700 300" role="img" aria-label="72 percent of requests hit the cache, 21 percent miss, 7 percent are stale.">
    <g transform="rotate(-90 170 150)">
      <circle class="seg primary" cx="170" cy="150" r="100" pathLength="100" stroke-dasharray="71 29" stroke-dashoffset="0"/>
      <circle class="seg accent"  cx="170" cy="150" r="100" pathLength="100" stroke-dasharray="20 80" stroke-dashoffset="-72"/>
      <circle class="seg muted"   cx="170" cy="150" r="100" pathLength="100" stroke-dasharray="6 94"  stroke-dashoffset="-93"/>
    </g>
    <text class="big" x="170" y="165" text-anchor="middle">72%</text>
    <g class="t">
      <rect class="f-primary" x="400" y="96"  width="18" height="18" rx="4"/><text x="430" y="111">Cache hit · 72%</text>
      <rect class="f-accent"  x="400" y="136" width="18" height="18" rx="4"/><text x="430" y="151">Miss · 21%</text>
      <rect class="f-muted"   x="400" y="176" width="18" height="18" rx="4"/><text x="430" y="191">Stale · 7%</text>
    </g>
  </svg>
</figure>
```

Keep the three circles as direct children of the group, in order (the stagger uses `:nth-child`). Label the segments directly as above instead of relying on color alone. Verified: renders, sweeps in on first visit and on return, text crisp at 1920×1080.

## Chart.js (only when CSS/SVG does not fit)

```html
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"
        integrity="sha384-vsrfeLOOY6KuIYKDlmVH5UiBmgIdB1oEf7p01YgWHuqmOHfZr374+odEv96n9tNC" crossorigin="anonymous"></script>

<section id="line">
  <h2>Pings stay below one cold write for 16 hours</h2>
  <div class="content">
    <p class="legend"><span><i></i>pings</span><span><i class="accent dash"></i>cold write</span></p>
    <div class="chart-box"><canvas id="c1" role="img" aria-label="Cumulative ping cost stays below the cold-write line."></canvas></div>
  </div>
</section>

<script>
const css = (n) => getComputedStyle(document.documentElement).getPropertyValue(n).trim();
Chart.defaults.color = css('--muted');
Chart.defaults.font.family = css('--font-body');
Chart.defaults.font.size = 16;
Chart.defaults.borderColor = 'rgba(128,128,128,.25)';

// Build the chart each time its slide is shown, so its animation plays on every visit, and destroy it
// when the slide is left. `build` must return the Chart. In print (PDF) and scroll views every slide is
// visible at once, so build once and keep it.
function whenShown(id, build) {
  let chart = null;
  const run = () => {
    const all = Reveal.getConfig().view === 'print' || Reveal.isScrollView();
    const here = all || Reveal.getCurrentSlide().id === id;
    if (here && !chart) chart = build();
    else if (!here && chart) { chart.destroy(); chart = null; }
  };
  Reveal.on('ready', run);
  Reveal.on('slidechanged', run);
}

whenShown('line', () => new Chart(document.getElementById('c1'), {
  type: 'line',
  data: {
    labels: [0, 30, 60, 90, 120],
    datasets: [
      { label: 'pings', data: [0, .1, .3, .5, .7], borderColor: css('--primary'), backgroundColor: css('--primary'), stepped: true, borderWidth: 3, pointRadius: 4 },
      { label: 'cold write', data: [.8, .8, .8, .8, .8], borderColor: css('--accent'), borderDash: [8, 6], borderWidth: 2, pointRadius: 0 },
    ],
  },
  options: {
    maintainAspectRatio: false,
    plugins: { legend: { display: false } },       // use the HTML .legend above (readable at slide scale)
    scales: { y: { beginAtZero: true, ticks: { callback: (v) => '$' + v } } },
  },
}));

Reveal.initialize({ width: 1280, height: 720, center: false, display: 'flex', hash: true, plugins: [] });
</script>
```

- **The canvas needs a sized, positioned parent** (`.chart-box`, fixed `height`) and `maintainAspectRatio: false`; otherwise it collapses or overflows.
- Read colors from the CSS variables (`css('--primary')`) after the stylesheet loads; do not hard-code hex.
- Doughnut: `type: 'doughnut'`, `options: { cutout: '62%', plugins: { legend: { position: 'bottom' } } }`, `borderColor: css('--surface')` on the dataset.
- Bar: `type: 'bar'`, `indexAxis: 'y'` for horizontal; `scales.y.beginAtZero: true`.
- Charts hidden by `display:none` slides measure 0×0 if created early. That is why `whenShown` creates them lazily.
- Chart.js animates only when a chart is created, so `whenShown` above destroys it on leaving and recreates it on each visit. If you create a chart once at load instead, it animates on the first visit only.
- **Blur when the window is larger than the deck.** reveal.js scales the slide up to fit the window (scale 1.32 at 1920 wide, about 2 at 2560, more in fullscreen on 4K). Text in the page stays crisp because the browser re-renders it, but a Chart.js `<canvas>` is a fixed-resolution bitmap that gets stretched, so axis and value labels look soft, as if zoomed. Measured: edge sharpness of chart text at 1920×1080 was about 10-15% lower than at 1280×720, and the loss grows with the scale. Options, in order of preference:
  1. **Use CSS bars or inline SVG** for simple charts (sections above). They are vector, crisp at any size, animate without JS and have no sizing race.
  2. **Raise the canvas resolution**: `options: { devicePixelRatio: 2 }` (3 for fullscreen on 4K). It sharpens the text and is set once at creation. Known limits found while testing: (a) setting `devicePixelRatio` from `Reveal.getScale()`, or calling `chart.resize()` after changing it, **broke the layout** (chart drawn larger than its box, spilling off the slide); do not do either; (b) even with a fixed value, in headless-Chrome screenshot runs about 1 in 3-6 loads rendered the chart oversized, while the default ratio was stable on every run. Cause not found; CSS containment on `.chart-box` did not remove it. If you use this option, screenshot the slide several times at your target size, and keep CSS/SVG as the fallback.
  3. Leave the default and accept slight softness on large screens.
- Chart.js resizes with its container; do not call `chart.resize()` yourself from a reveal `resize` handler (see above).
- Disable animation for PDF/print with `options.animation = Reveal.getConfig().view === 'print' ? false : {}`.
- Self-hosting: download `chart.umd.min.js` next to the deck for offline decks.

## JS-built SVG (custom charts, tooltips)

Use when you need something Chart.js does not do (annotated crossing points, a draw-in step line, bespoke tooltips). Pattern: write scale functions, build the SVG string, assign it to `el.innerHTML`.

```js
const W = 1160, H = 340, L = 60, R = 16, T = 20, B = 40;
const X = (t) => L + (W - L - R) * t / xMax;
const Y = (v) => T + (H - T - B) * (1 - v / yMax);
// grid + ticks, then:
const d = points.map((p, i) => (i ? 'L' : 'M') + X(p.t) + ' ' + Y(p.v)).join(' ');
el.innerHTML = `<svg viewBox="0 0 ${W} ${H}" role="img" aria-label="${summary}">
  <path class="draw" pathLength="1" d="${d}" fill="none" stroke="var(--primary)" stroke-width="3"/></svg>`;
```

Tooltip: listen to `pointermove` on a transparent `<rect>` covering the plot, convert `clientX` to SVG units with `(ev.clientX - rect.left) * W / rect.width` (this is scale-safe), then position an absolutely placed `.tip` div in %. Add `data-prevent-swipe` on the container so touch drags do not change slides. Create the chart at load; the `.draw` animation plays when the slide becomes current.

## Interactive controls

Sliders, selects and buttons work inside slides.

```html
<div class="content cols-2" data-prevent-swipe>
  <div class="card">
    <div class="field"><label for="gap">Pause <output id="gapo">2h</output></label>
      <input id="gap" type="range" min="5" max="240" step="5" value="120"></div>
    <div class="field"><label for="m">Model</label><select id="m"><option>Sonnet</option><option>Haiku</option></select></div>
  </div>
  <div class="stat"><p class="value" id="out">2</p><p class="label">pings during the pause</p></div>
</div>
```

```js
Reveal.initialize({
  width: 1280, height: 720, center: false, display: 'flex',
  // arrow keys must move the slider/select, not the deck
  keyboardCondition: (ev) => !(ev.target && ['INPUT', 'SELECT', 'TEXTAREA'].includes(ev.target.tagName)),
});
```

- `data-prevent-swipe` on the interactive container stops touch drags on a slider from changing slides.
- Use `aria-live="polite"` on result elements and real `<label for>`.
- Keep the logic pure and small (`function result(inputs) {...}`) so it can be tested in a page script.
- Interactive slides do not export to PDF as interactive; make the default state a meaningful picture.

## Motion and accessibility

- Respect reduced motion: the stylesheet already disables bar/draw transitions under `prefers-reduced-motion`. Also set `transition` via `window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'none' : 'slide'`.
- Every chart/diagram has `role="img"` + `aria-label` with the takeaway, and the same facts appear as text on the slide (a caption or a table). Never rely on color alone: pair series with direct labels or dashed vs solid lines.
- Test the stepped states: screenshot `#/<h>/<v>/<fragment>`.
