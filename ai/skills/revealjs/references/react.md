# React: `@revealjs/react` (6.0+)

Docs: react. Official wrapper: describe slides as components. (`react-legacy` page documents the older wrapper, not covered here.)

```sh
npm i @revealjs/react reveal.js react react-dom
```

Import CSS/theme/plugins yourself (the package ships only bindings):

```jsx
import { Deck, Slide, Stack, Fragment, Code, Markdown, useReveal } from '@revealjs/react';
import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';
import 'reveal.js/plugin/highlight/monokai.css';
import RevealHighlight from 'reveal.js/plugin/highlight';

export function Presentation() {
  return (
    <Deck config={{ width: 1280, height: 720, hash: true }} plugins={[RevealHighlight]}>
      <Slide><h1>Hello</h1></Slide>
      <Slide background="#111827"><h2>Second</h2></Slide>
      <Stack>
        <Slide>Vertical 1</Slide>
        <Slide>Vertical 2</Slide>
      </Stack>
    </Deck>
  );
}
```

## Components

- **`Deck`**: one reveal instance (created on mount, destroyed on unmount). Props: `config`, `plugins` (init-only, captured on first mount), event props, `deckRef`.
- **`Slide`**: a `<section>`. Props map to `data-*`:
  - Background: `background`, `backgroundColor`, `backgroundImage`, `backgroundVideo`, `backgroundVideoLoop`, `backgroundVideoMuted`, `backgroundIframe`, `backgroundGradient`, `backgroundSize`, `backgroundPosition`, `backgroundRepeat`, `backgroundOpacity`, `backgroundTransition`, `backgroundInteractive`
  - Auto-animate: `autoAnimate`, `autoAnimateId`, `autoAnimateRestart`, `autoAnimateUnmatched`, `autoAnimateEasing`, `autoAnimateDuration`, `autoAnimateDelay`
  - Other: `transition`, `transitionSpeed`, `autoSlide`, `visibility`, `notes`, `preload`; extra `data-*` pass through.
- **`Stack`**: vertical stack wrapper.
- **`Fragment`**: renders a `<span>`; `as="p"` changes the element, `asChild` merges onto the child; `animation="fade-up"`, `index={2}`.
- **`Code`**: `language`, children string or `code` prop, `lineNumbers` (`true` or `"1|2-3"` steps), `startFrom`, `noEscape`, `trim` (default true). Needs the highlight plugin on `Deck`.
- **`Markdown`**: no markdown plugin needed. Children string or `markdown`/`src` (external file, fetched async). `separator` (default `---`), `verticalSeparator`, `notesSeparator` (default `Notes:`), `options` (`animateLists`, `smartypants`, any marked option). Accepts `Slide` props for every slide it generates. Supports `<!-- .element: -->` and `<!-- .slide: -->` comments.

## Events

`Deck` props: `onReady`, `onSync`, `onSlideSync`, `onSlideChange`, `onSlideTransitionEnd`, `onFragmentShown`, `onFragmentHidden`, `onOverviewShown`, `onOverviewHidden`, `onPaused`, `onResumed`.

## API access

```jsx
function NextButton() {
  const deck = useReveal();               // inside the Deck tree; may be null before ready
  return <button onClick={() => deck?.next()}>Next</button>;
}
// outside the tree
const deckRef = useRef(null);
<Deck deckRef={deckRef}>...</Deck>
```

## How it behaves

- Init is async; `onReady` fires after `initialize()` resolves.
- `Deck` calls `sync()` when the slide structure changes (add/remove/reorder/regroup), not on content edits.
- `Slide` updates its `data-*` with `syncSlide()`.
- `config` is shallow-compared; `configure()` runs only on real changes.
- `plugins` are ignored after first mount.
