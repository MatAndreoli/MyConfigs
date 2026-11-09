# JavaScript API and presentation state

Docs: api, presentation-state. Global `Reveal` for a single deck; use the instance for multiple decks.

## Navigation

```js
Reveal.slide(indexh, indexv, indexf);
Reveal.left(); Reveal.right(); Reveal.up(); Reveal.down(); Reveal.prev(); Reveal.next();
Reveal.navigateFragment(indexf);   // -1 = all fragments hidden
Reveal.prevFragment(); Reveal.nextFragment();
Reveal.availableRoutes();          // {top, right, bottom, left}
Reveal.availableFragments();       // {prev, next}
```

## Misc

```js
Reveal.sync();                     // after adding/removing slides: updates controls, progress, classes
Reveal.syncSlide(slide); Reveal.syncFragments(slide);
Reveal.layout();                   // recompute scale
Reveal.shuffle();
Reveal.getConfig(); Reveal.getScale(); Reveal.getComputedSlideSize();
Reveal.getIndices(slide);          // { h, v, f }
Reveal.getProgress();              // 0..1
Reveal.getSlidesAttributes();
Reveal.getSlideBackground(h, v);
Reveal.getSlideNotes(slide);
Reveal.getQueryHash();
Reveal.getSlidePath(slide);
```

## Slides

```js
Reveal.getSlide(h, v); Reveal.getPreviousSlide(); Reveal.getCurrentSlide();
Reveal.getHorizontalSlides(); Reveal.getVerticalSlides();
Reveal.getTotalSlides(); Reveal.getSlidePastCount(); Reveal.getSlides();
Reveal.removeHiddenSlides();
```

## State checks

```js
Reveal.hasHorizontalSlides(); Reveal.hasVerticalSlides();
Reveal.hasNavigatedHorizontally(); Reveal.hasNavigatedVertically();
Reveal.isFirstSlide(); Reveal.isLastSlide(); Reveal.isVerticalSlide(); Reveal.isLastVerticalSlide();
```

## Modes

```js
Reveal.toggleHelp(); Reveal.toggleOverview(); Reveal.toggleAutoSlide(); Reveal.togglePause();
Reveal.isOverview(); Reveal.isAutoSliding(); Reveal.isPaused();   // toggles accept true/false
```

## DOM

`Reveal.getRevealElement()` (`.reveal`), `getSlidesElement()` (`.slides`), `getViewportElement()` (`.reveal-viewport`), `getBackgroundsElement()` (`.backgrounds`).

## Presentation state (snapshot)

```js
Reveal.slide(1);
let state = Reveal.getState();     // {indexh, indexv, indexf, paused, overview}
Reveal.slide(3);
Reveal.setState(state);            // back to slide 1
```

A plain object: stringify, persist or send over the wire.

## Related

Events: `events.md`. Keys: `navigation-controls.md`. Plugins: `plugins.md`. Cross-window control: `postmessage.md`.
