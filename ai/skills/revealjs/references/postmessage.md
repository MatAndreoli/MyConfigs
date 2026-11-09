# postMessage API

Docs: postmessage. Control a deck from another window (e.g. the deck in an iframe) and receive its events.

## Call a method

```js
revealWindow.postMessage(JSON.stringify({ method: 'slide', args: [2] }), '*');
```

Any API method works (`api.md`).

## Callbacks (return values)

```js
revealWindow.postMessage(JSON.stringify({ method: 'getTotalSlides' }), '*');
window.addEventListener('message', (event) => {
  const data = JSON.parse(event.data);
  if (data.namespace === 'reveal' && data.eventName === 'callback' && data.method === 'getTotalSlides') {
    data.result; // total slides
  }
});
```

## Events bubbled to the parent

When the deck runs in an iframe with `postMessageEvents: true`:

```js
window.addEventListener('message', (event) => {
  const data = JSON.parse(event.data);
  if (data.namespace === 'reveal' && data.eventName === 'slidechanged') {
    // data.state has the slide position
  }
});
```

Messages are JSON strings with `namespace`, `eventName`, `state`.

## Flags

```js
Reveal.initialize({ postMessage: true /* default */, postMessageEvents: false /* default */ });
```

Security: `'*'` as target origin accepts any sender; with untrusted embedders, set `postMessage: false` or validate `event.origin` on the parent side.
