# Slide layout patterns

Copy-paste patterns for `assets/base-styles.css` (see `design.md` for setup: `display: 'flex'`, 1280×720, `center: false`). Every snippet below was rendered and checked. Classes are defined in the stylesheet; to restyle, change tokens, not the markup.

Structure of a normal slide: `<section id="..."> <h2>Heading</h2> <div class="content">...</div> </section>`. `.content` fills the space under the title and centers its children; add `top` (`class="content top"`) for dense slides. Put a grid class (`cols-*`) on the `.content` element itself or on a div inside it.

## Pick a pattern

| Message | Pattern |
|---|---|
| Opening / closing | Title slide |
| New section | Section divider |
| 3-5 supporting points | Bullets + callout |
| 3 parallel ideas | Cards |
| Key numbers | Stats |
| Sequence, roadmap, process | Steps |
| Architecture, pipeline, request path | Flow diagram |
| One chart + the numbers to remember | Chart + KPI cards |
| A trend with a key moment | Annotated chart |
| Milestones over time | Dotted timeline |
| Stages of a pipeline, one highlighted | Chevron process bar |
| Map of a flow, then what each part does | Detail slide: mini flow + cards |
| Compare values, trends, shares | Chart slide (`charts-and-graphics.md`: CSS bars or SVG first, Chart.js only if needed) |
| "Try it with your numbers" | Interactive controls (`charts-and-graphics.md`) |
| A topic with overview + optional detail | Topic stack (`vertical-slides.md`) |
| Before/after, option A/B, specs | Table |
| Voice of customer, principle | Quote |
| Technical how-to | Code + explanation |
| Mood, product shot, section break | Image background |

Vary the pattern between neighbors.

## Title / closing

```html
<section id="title" class="title-slide">
  <p class="eyebrow">Q4 Platform Review</p>
  <div class="rule"></div>
  <h1>Faster releases, fewer incidents</h1>
  <p class="subtitle">Engineering · November 2026</p>
</section>
```

Closing: same classes with `<h1>Questions?</h1>`, rule, contact line.

## Section divider

```html
<section id="what-changed" class="section-divider">
  <p class="num">02</p>
  <h2>What changed</h2>
  <p class="lead muted">Three shifts in how we ship</p>
</section>
```

## Bullets + callout (2/3 + 1/3)

```html
<section id="why">
  <h2>Why it matters</h2>
  <div class="content cols-2-1 center-y">
    <ul>
      <li><strong>Lead time</strong> dropped from 9 days to 2</li>
      <li>Rollbacks are <strong>one command</strong></li>
      <li>On-call pages fell by a third</li>
    </ul>
    <div class="callout"><p>Median deploy is now under 12 minutes.</p></div>
  </div>
</section>
```

Few bullets? Add class `lead` to the `<ul>` for 30px text. Column helpers: `cols-2`, `cols-3`, `cols-4`, `cols-1-2`, `cols-2-1`; `center-y` centers items vertically within the row.

## Cards (3 across)

```html
<section id="pillars">
  <h2>Three pillars</h2>
  <div class="content cols-3">
    <div class="card"><span class="icon">⚙️</span><h3>Automate</h3><p>Pipelines build, test and deploy on merge.</p></div>
    <div class="card"><span class="icon">📈</span><h3>Observe</h3><p>One dashboard per service with SLOs.</p></div>
    <div class="card"><span class="icon">↩️</span><h3>Recover</h3><p>Rollback and feature flags by default.</p></div>
  </div>
</section>
```

Keep titles one line so cards align (equal heights come from `align-items: stretch`). Use `cols-2` for two larger cards.

## Stats

```html
<section id="results">
  <h2>Results</h2>
  <div class="content cols-4">
    <div class="stat"><p class="value">2d</p><p class="label">Lead time</p></div>
    <div class="stat"><p class="value">-34%</p><p class="label">Pages per week</p></div>
    <div class="stat"><p class="value">99.95%</p><p class="label">Availability</p></div>
    <div class="stat"><p class="value">12m</p><p class="label">Median deploy</p></div>
  </div>
</section>
```

Use `cols-3` for three stats. Add a `.callout` under the grid for the takeaway.

## Steps (process / roadmap)

```html
<section id="rollout">
  <h2>Rollout plan</h2>
  <div class="content">
    <div class="steps">
      <div class="step"><h3>Pilot</h3><p>Two teams, four weeks</p></div>
      <div class="step"><h3>Expand</h3><p>All web services</p></div>
      <div class="step"><h3>Migrate</h3><p>Legacy batch jobs</p></div>
      <div class="step"><h3>Retire</h3><p>Old release tooling</p></div>
    </div>
    <p class="muted">Each phase ends with a go/no-go on error budget.</p>
  </div>
</section>
```

Numbers are automatic (CSS counter). 3-5 steps fit one row; more → two slides.

## Flow diagram (architecture / pipeline)

```html
<section id="architecture">
  <h2>Services react to events</h2>
  <div class="content">
    <div class="flow">
      <div class="node"><h3>Checkout API</h3><p>emits payment.requested</p></div><span class="arrow">→</span>
      <div class="node on"><h3>Event broker</h3><p>Kafka, keyed by paymentId</p></div><span class="arrow">→</span>
      <div class="node hl"><h3>Payment core</h3><p>state machine + outbox</p></div><span class="arrow">→</span>
      <div class="node"><h3>Ledger, Fraud</h3><p>independent consumers</p></div>
    </div>
    <p class="callout">Producers no longer know who consumes their events.</p>
  </div>
</section>
```

`.node.on` outlines in the primary color (the component to look at), `.node.hl` in the accent (the one that changed). Keep to 3-5 nodes per row and one line of text per node; for more, use two slides. For branching diagrams, draw an inline SVG using the palette tokens (`fill: var(--surface)`, `stroke: var(--primary)`).

## Quote

```html
<section id="quote">
  <blockquote>
    <p>We stopped fearing Friday deploys.</p>
    <cite>Staff engineer, payments</cite>
  </blockquote>
</section>
```

The blockquote centers itself vertically; no heading needed.

## Table (comparison)

```html
<section id="before-after">
  <h2>Before and after</h2>
  <div class="content">
    <table class="big">
      <tr><th>Metric</th><th>Before</th><th>After</th></tr>
      <tr><td>Lead time</td><td>9 days</td><td><strong>2 days</strong></td></tr>
      <tr><td>Rollback</td><td>45 min, manual</td><td><strong>1 command</strong></td></tr>
    </table>
  </div>
</section>
```

`class="big"` for ≤ 4 rows; omit it for 5-6 rows.

## Code + explanation

```html
<section id="rollback">
  <h2>One command to roll back</h2>
  <div class="content cols-1-2 center-y">
    <div>
      <p>Pass the release id; the pipeline restores the previous artifact.</p>
      <span class="pill">CLI</span><span class="pill">idempotent</span>
    </div>
    <pre><code data-trim data-line-numbers="1|2-3" class="language-bash">deploy rollback payments --to v142
deploy status payments
# → healthy, 3/3 replicas</code></pre>
  </div>
</section>
```

Needs the highlight plugin (`code.md`). With `data-line-numbers="1|2-3"` the first step dims the other lines: that is the step highlight, not a bug. Code-only slide: drop the left column and let the `<pre>` take the full width. A caption below the `<pre>` is safe with `assets/base-styles.css`; with other CSS see the stacked-`<code>` gotcha in `code.md`.

## Image background (hero / divider)

```html
<section id="hero" class="title-slide on-image"
         data-background-color="#000"
         data-background-image="photo.jpg" data-background-opacity="0.5">
  <h1>Ship with confidence</h1>
</section>
```

`on-image` forces white text with a soft shadow, so the area behind it **must be dark**. Always set a dark `data-background-color` under the image and lower `data-background-opacity` (0.4-0.6) until contrast holds; without the dark base, a light palette (`paper`, `ink`, `sand`) washes the image out and the white text disappears. Use a file path or a base64 data URI for the image: reveal.js writes it into an unquoted CSS `url()`, so a URI containing quotes, spaces or parentheses silently fails. See `backgrounds.md`.

## Image + text

```html
<section id="product">
  <h2>The new console</h2>
  <div class="content cols-2 center-y">
    <ul><li>One place for deploys</li><li>Live health per service</li></ul>
    <img class="media-fill" src="console.png" alt="Console screenshot" style="height: 420px" />
  </div>
</section>
```

## Chart + KPI cards

A chart that proves the heading, with the 3 numbers a viewer should remember beside it. Chart is inline SVG (vector, crisp at any scale); author its `viewBox` near its on-screen size.

```html
<section id="chartkpi">
  <h2>Authorize p95 fell from 1.1 s to 340 ms</h2>
  <div class="content cols-2-1 center-y">
    <figure class="fig">
      <svg viewBox="0 0 760 300" role="img" aria-label="Authorize p95 latency by release: 1.1 s, 820 ms, 510 ms, 340 ms.">
        <line class="grid" x1="50" x2="750" y1="20" y2="20"/><line class="grid" x1="50" x2="750" y1="100" y2="100"/><line class="grid" x1="50" x2="750" y1="180" y2="180"/>
        <line class="axis" x1="50" x2="750" y1="260" y2="260"/>
        <g class="tick"><text x="44" y="24" text-anchor="end">1.2s</text><text x="44" y="104" text-anchor="end">0.8s</text><text x="44" y="184" text-anchor="end">0.4s</text><text x="44" y="264" text-anchor="end">0</text></g>
        <rect class="f-muted" x="90" y="52" width="100" height="208" rx="4"/><rect class="f-muted" x="250" y="104" width="100" height="156" rx="4"/>
        <rect class="f-muted" x="410" y="164" width="100" height="96" rx="4"/><rect class="f-accent" x="570" y="196" width="100" height="64" rx="4"/>
        <g class="t" text-anchor="middle"><text x="140" y="42">1.1 s</text><text x="300" y="94">820 ms</text><text x="460" y="154">510 ms</text><text x="620" y="186">340 ms</text></g>
        <g class="s" text-anchor="middle"><text x="140" y="284">v1</text><text x="300" y="284">v2</text><text x="460" y="284">v3</text><text x="620" y="284">v4</text></g>
      </svg>
      <figcaption>p95 latency per release. Source: APM, 7-day window.</figcaption>
    </figure>
    <div class="kpis">
      <div class="stat"><p class="value">−69%</p><p class="label">p95 latency</p></div>
      <div class="stat"><p class="value">12×</p><p class="label">fewer timeouts</p></div>
      <div class="stat"><p class="value">0</p><p class="label">rollbacks</p></div>
    </div>
  </div>
</section>
```

## Annotated chart (marker + callout)

Name the moment that matters directly on the chart: a dashed threshold, a marker dot, a leader line and a two-line label. The line draws in when the slide appears (`.draw`). Put y-axis tick labels in a `<g class="tick">`.

```html
<section id="annot">
  <h2>Pings stay cheaper than one cold write for 16 hours</h2>
  <div class="content">
    <figure class="fig">
      <svg viewBox="0 0 1100 320" role="img" aria-label="Cumulative ping cost crosses the cold-write cost at 16 hours.">
        <line class="grid" x1="60" x2="1090" y1="40" y2="40"/><line class="grid" x1="60" x2="1090" y1="140" y2="140"/><line class="grid" x1="60" x2="1090" y1="240" y2="240"/>
        <line class="axis" x1="60" x2="1090" y1="280" y2="280"/>
        <g class="tick"><text x="52" y="44" text-anchor="end">$0.8</text><text x="52" y="144" text-anchor="end">$0.4</text><text x="52" y="284" text-anchor="end">0</text><text x="60" y="302">0h</text><text x="575" y="302" text-anchor="middle">12h</text><text x="1090" y="302" text-anchor="end">24h</text></g>
        <path d="M60 40 H1090" stroke="var(--accent)" stroke-width="2" stroke-dasharray="8 6" fill="none"/>
        <text class="s" x="1090" y="30" text-anchor="end" style="fill:var(--accent)">cold write $0.80</text>
        <path class="draw" pathLength="1" d="M60 280 L260 250 L460 205 L660 150 L860 95 L1060 40" stroke="var(--primary)" stroke-width="4" fill="none"/>
        <circle class="f-accent" cx="1060" cy="40" r="9"/>
        <path class="link" d="M1050 52 L960 120"/>
        <text class="t" x="860" y="145">Break-even at 16 h</text>
        <text class="s" x="860" y="166">pings = one cold write</text>
      </svg>
    </figure>
  </div>
</section>
```

## Dotted timeline

```html
<section id="timeline">
  <h2>Rollout in four steps</h2>
  <div class="content">
    <div class="timeline">
      <div class="tl"><p class="when">Mar</p><h3>Pilot</h3><p>One squad, 5% of traffic</p></div>
      <div class="tl"><p class="when">Apr</p><h3>Expand</h3><p>All squads, 25%</p></div>
      <div class="tl on"><p class="when">May</p><h3>Cut over</h3><p>100% of traffic</p></div>
      <div class="tl"><p class="when">Jun</p><h3>Retire</h3><p>Remove the old path</p></div>
    </div>
  </div>
</section>
```

Add `on` to the current or key milestone. 3-5 items. Sparse by nature: add a `.lead` sentence or callout under it rather than leaving it alone.

## Chevron process bar

```html
<section id="chev">
  <h2>From idea to production</h2>
  <div class="content">
    <div class="chevrons"><div class="chev">Plan</div><div class="chev">Build</div><div class="chev on">Review</div><div class="chev">Ship</div><div class="chev">Measure</div></div>
    <p class="lead">The <strong>review</strong> stage is where most rework appears, so that is where we added automation.</p>
  </div>
</section>
```

Highlight the stage the slide is about with `on`; 4-6 stages. Follow with one `.lead` sentence about the highlighted stage.

## Detail slide: mini flow + cards

A compact flow gives the map, the cards explain each stop. Use `content top` so it starts under the title.

```html
<section id="detail">
  <h2>How a payment request travels</h2>
  <div class="content top">
    <div class="flow mini"><div class="node"><h3>App</h3></div><span class="arrow">→</span><div class="node on"><h3>Gateway</h3></div><span class="arrow">→</span><div class="node"><h3>Authorize</h3></div><span class="arrow">→</span><div class="node"><h3>Ledger</h3></div></div>
    <div class="cols-3">
      <div class="card"><h3>Gateway</h3><p>Validates the token and rate limits per client.</p></div>
      <div class="card"><h3>Authorize</h3><p>Checks balance and risk score in under 400 ms.</p></div>
      <div class="card"><h3>Ledger</h3><p>Writes the entry once, idempotent by request id.</p></div>
    </div>
  </div>
</section>
```

## Slide footnote / source

```html
<p class="footnote">Source: internal deploy metrics, Q3-Q4 2026</p>
```

Put it as the **last child of the `<section>`, after the `.content` div**. It sits in the flow at the bottom of the slide (not absolutely positioned), so it cannot end up under the bottom-center arrow of `controlsLayout: 'edges'`. Keep it to one line.

## Building blocks inside any slide

| Class | Use |
|---|---|
| `.eyebrow` | Small uppercase label above a heading |
| `.lead` | 30px intro / statement text |
| `.muted`, `.accent`, `.center`, `.small` | Text utilities |
| `.pill` | Tags |
| `.callout` | One-sentence takeaway with a side bar |
| `.rule` | Short accent bar under an eyebrow/title |
| `.card`, `.stat`, `.step` | Panels |
| `r-stack`, `r-fit-text`, `r-stretch`, `r-frame` | reveal helpers (`layout.md`) |
| `.fragment` | Step-by-step reveal (`fragments.md`) |

## Rules of thumb

- Inline `style` only for one-off sizes (an image height); anything repeating 3+ times belongs in a class in `styles.css`.
- All visible text goes in `<p>`, `<li>`, `<h1>`-`<h6>`, `<td>`/`<th>`, `<cite>`: bare text in a `div` or `span` skips the base size/color.
- Unique `id` on every `<section>`.
