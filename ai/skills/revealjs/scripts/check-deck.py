#!/usr/bin/env python3
"""Screenshot every slide (and every fragment / code-highlight step) of a reveal.js deck and report layout problems.

Usage: python3 check-deck.py deck.html [--out DIR] [--size 1280x720] [--settle 1.5]

Needs headless Chrome/Chromium on PATH (google-chrome, chromium, chrome). No other dependencies.

How it works: the deck's folder is served over http://127.0.0.1 (so external Markdown, iframes and fetches work,
unlike file://), one headless Chrome is driven over the DevTools protocol, and each slide is visited in REAL time.
After each navigation the script waits --settle seconds so entrance animations (bars, draw-in, charts) finish
before the screenshot. Nothing is injected into the deck file.

Output: DIR/s<h>-<v>.png (nothing built: fragment -1) plus DIR/s<h>-<v>-step<i>.png for every fragment or
code-highlight step (up to 12 per slide). Default DIR: <deck dir>/shots.

Checks per slide, at its fully built state:
  overflow            the slide scrolls (content taller/wider than the slide)
  outside-slide       an element sticks out of the slide box (catches centered content spilling over a title)
  small-text          text under 16px (SVG and KaTeX excluded)
  contrast            text below 4.5:1 (3:1 for text >= 24px). Skipped over image/video/iframe/gradient backgrounds.
  empty-slide         a slide with no text, media or background (e.g. an external Markdown file that failed to load)
  http-error          a file the deck requests returned 4xx/5xx (counted as a problem; favicon ignored)
Page errors (uncaught exceptions, failed requests) are listed as warnings. Exit code 1 if any check failed.
"""
import argparse, base64, functools, http.server, json, os, shutil, socket, struct, subprocess, sys, tempfile, threading, time, urllib.request

CHECK_JS = r"""
(function () {
  function rgba(s) {
    var m = s.match(/rgba?\(([^)]+)\)/);
    if (m) { var p = m[1].split(/[ ,\/]+/).filter(Boolean).map(parseFloat); return [p[0], p[1], p[2], p.length > 3 ? p[3] : 1]; }
    m = s.match(/color\(srgb ([^)]+)\)/);
    if (m) { var q = m[1].split(/[ \/]+/).filter(Boolean).map(parseFloat); return [q[0] * 255, q[1] * 255, q[2] * 255, q.length > 3 ? q[3] : 1]; }
    return [0, 0, 0, 0];
  }
  function lum(c) { var f = function (v) { v /= 255; return v <= .03928 ? v / 12.92 : Math.pow((v + .055) / 1.055, 2.4); }; return .2126 * f(c[0]) + .7152 * f(c[1]) + .0722 * f(c[2]); }
  function ratio(a, b) { var x = lum(a), y = lum(b); return (Math.max(x, y) + .05) / (Math.min(x, y) + .05); }
  function colorOf(v) { var t = document.createElement('i'); t.style.color = v; document.body.appendChild(t); var r = rgba(getComputedStyle(t).color); t.remove(); return r; }
  // Background behind a slide: its own data-background-* (backgrounds live in .backgrounds, not in ancestors)
  function slideBg(s) {
    var a = function (n) { return s.getAttribute('data-background-' + n); };
    if (a('image') || a('video') || a('iframe') || a('gradient') || s.hasAttribute('data-background')) {
      var plain = s.getAttribute('data-background');
      if (plain && !/^(url|linear|radial|conic)|[\/.]/.test(plain)) return colorOf(plain);
      return null;                                           // cannot judge text over pictures
    }
    if (a('color')) return colorOf(a('color'));
    var base = rgba(getComputedStyle(document.querySelector('.reveal')).getPropertyValue('--r-background-color') || '');
    if (base[3] > .9) return base;
    return rgba(getComputedStyle(document.body).backgroundColor);
  }
  function bgOf(el, slide, sbg) {
    for (var e = el; e && e !== slide.parentElement && e.nodeType === 1; e = e.parentElement) {
      var cs = getComputedStyle(e);
      if (cs.backgroundImage !== 'none') return null;        // image or gradient: cannot judge
      var c = rgba(cs.backgroundColor);
      if (c[3] > .9) return c;
    }
    return sbg;
  }
  function label(el) { return el.tagName.toLowerCase() + (typeof el.className === 'string' && el.className.trim() ? '.' + el.className.trim().split(/\s+/)[0] : '') + ': ' + (el.textContent || '').trim().replace(/\s+/g, ' ').slice(0, 40); }
  function clippedByAncestor(el, s) {
    for (var a = el.parentElement; a && a !== s; a = a.parentElement) { var o = getComputedStyle(a); if (o.overflowX !== 'visible' || o.overflowY !== 'visible') return true; }
    return false;
  }
  window.__checkSlide = function (s) {
    var issues = [], seen = {};
    if (s.scrollHeight > s.clientHeight + 2) issues.push('overflow-y ' + (s.scrollHeight - s.clientHeight) + 'px');
    if (s.scrollWidth > s.clientWidth + 2) issues.push('overflow-x ' + (s.scrollWidth - s.clientWidth) + 'px');
    var sr = s.getBoundingClientRect(), outside = 0;
    s.querySelectorAll('*').forEach(function (el) {
      if (outside >= 5 || el.closest('aside, script, style') || (el.closest('svg') && el.tagName.toLowerCase() !== 'svg')) return;
      var cs = getComputedStyle(el);
      if (cs.display === 'none' || cs.visibility === 'hidden' || cs.position === 'fixed') return;
      var r = el.getBoundingClientRect();
      if (r.width < 1 || r.height < 1) return;
      if (r.left < sr.left - 2 || r.right > sr.right + 2 || r.top < sr.top - 2 || r.bottom > sr.bottom + 2) {
        if (!clippedByAncestor(el, s)) { outside++; issues.push('outside-slide ' + label(el)); }
      }
    });
    if (!(s.innerText || '').trim() && !s.querySelector('img,video,iframe,svg,canvas,pre,table,object') && !s.hasAttribute('data-background-image') && !s.hasAttribute('data-background-video') && !s.hasAttribute('data-background-iframe') && !s.hasAttribute('data-background-color') && !s.hasAttribute('data-background-gradient')) issues.push('empty-slide (a data-markdown file that failed to load?)');
    var sbg = slideBg(s);
    var w = document.createTreeWalker(s, NodeFilter.SHOW_TEXT);
    while (w.nextNode()) {
      var n = w.currentNode, el = n.parentElement;
      if (!n.textContent.trim() || !el || el.closest('svg, aside.notes, script, style, .katex')) continue;
      var cs = getComputedStyle(el), px = parseFloat(cs.fontSize);
      if (cs.display === 'none' || cs.visibility === 'hidden') continue;
      if (px < 16 && !seen['f' + label(el)]) { seen['f' + label(el)] = 1; issues.push('small-text ' + px + 'px  ' + label(el)); }
      var bg = bgOf(el, s, sbg), fg = rgba(cs.color);
      if (bg && fg[3] > .5) {
        var r = ratio(fg, bg), need = px >= 24 || (px >= 18.7 && parseInt(cs.fontWeight) >= 700) ? 3 : 4.5;
        if (r < need && !seen['c' + label(el)]) { seen['c' + label(el)] = 1; issues.push('contrast ' + r.toFixed(2) + ':1 (need ' + need + ')  ' + label(el)); }
      }
    }
    return issues;
  };
})();
"""


class WS:
    """Minimal WebSocket client (text frames only), enough for the Chrome DevTools protocol."""
    def __init__(self, host, port, path):
        self.s = socket.create_connection((host, port), timeout=60)
        key = base64.b64encode(os.urandom(16)).decode()
        self.s.sendall(('GET %s HTTP/1.1\r\nHost: %s:%d\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n'
                        'Sec-WebSocket-Key: %s\r\nSec-WebSocket-Version: 13\r\n\r\n' % (path, host, port, key)).encode())
        self.buf = b''
        while b'\r\n\r\n' not in self.buf:
            self.buf += self._read(1)
        head, self.buf = self.buf.split(b'\r\n\r\n', 1)
        if b' 101 ' not in head.split(b'\r\n')[0]:
            raise RuntimeError('WebSocket handshake failed: ' + head.decode(errors='replace'))

    def _read(self, n):
        d = self.s.recv(max(n, 65536))
        if not d: raise ConnectionError('DevTools connection closed')
        return d

    def _need(self, n):
        while len(self.buf) < n: self.buf += self._read(n - len(self.buf))
        out, self.buf = self.buf[:n], self.buf[n:]
        return out

    def send(self, text):
        data = text.encode(); mask = os.urandom(4); n = len(data)
        if n < 126: head = bytes([0x81, 0x80 | n])
        elif n < 65536: head = bytes([0x81, 0x80 | 126]) + struct.pack('>H', n)
        else: head = bytes([0x81, 0x80 | 127]) + struct.pack('>Q', n)
        self.s.sendall(head + mask + bytes(b ^ mask[i % 4] for i, b in enumerate(data)))

    def recv(self):
        msg = b''
        while True:
            b1, b2 = self._need(2)
            op, n = b1 & 0x0f, b2 & 0x7f
            if n == 126: n = struct.unpack('>H', self._need(2))[0]
            elif n == 127: n = struct.unpack('>Q', self._need(8))[0]
            payload = self._need(n)
            if op == 8: raise ConnectionError('DevTools connection closed')
            if op in (9, 10): continue
            msg += payload
            if b1 & 0x80: return msg.decode()


class CDP:
    def __init__(self, ws):
        self.ws, self.i, self.events = ws, 0, []

    def call(self, method, **params):
        self.i += 1; mid = self.i
        self.ws.send(json.dumps({'id': mid, 'method': method, 'params': params}))
        while True:
            m = json.loads(self.ws.recv())
            if m.get('id') == mid:
                if 'error' in m: raise RuntimeError('%s: %s' % (method, m['error']))
                return m.get('result', {})
            if 'method' in m: self.events.append(m)

    def js(self, expr):
        r = self.call('Runtime.evaluate', expression=expr, returnByValue=True, awaitPromise=True)
        if 'exceptionDetails' in r: raise RuntimeError('page script error: ' + json.dumps(r['exceptionDetails'])[:300])
        return r['result'].get('value')


def find_chrome():
    for n in ('google-chrome', 'google-chrome-stable', 'chromium', 'chromium-browser', 'chrome'):
        p = shutil.which(n)
        if p: return p
    sys.exit('No headless Chrome/Chromium found on PATH.')


def free_port():
    with socket.socket() as s:
        s.bind(('127.0.0.1', 0)); return s.getsockname()[1]


class Quiet(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *a): pass


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('deck'); ap.add_argument('--out'); ap.add_argument('--size', default='1280x720')
    ap.add_argument('--settle', type=float, default=1.5, help='seconds to wait after each navigation (animations)')
    a = ap.parse_args()
    deck = os.path.abspath(a.deck); d = os.path.dirname(deck)
    out = os.path.abspath(a.out or os.path.join(d, 'shots')); os.makedirs(out, exist_ok=True)
    w, h = [int(x) for x in a.size.lower().split('x')]

    srv = http.server.ThreadingHTTPServer(('127.0.0.1', 0), functools.partial(Quiet, directory=d))
    threading.Thread(target=srv.serve_forever, daemon=True).start()
    url = 'http://127.0.0.1:%d/%s' % (srv.server_address[1], os.path.basename(deck))

    port, prof = free_port(), tempfile.mkdtemp(prefix='checkdeck-')
    chrome = subprocess.Popen([find_chrome(), '--headless', '--no-sandbox', '--disable-gpu', '--hide-scrollbars',
                               '--remote-debugging-port=%d' % port, '--user-data-dir=' + prof, '--window-size=%d,%d' % (w, h), 'about:blank'],
                              stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    problems, warnings, httperrs, nslides = 0, [], [], 0
    try:
        target = None
        for _ in range(100):
            try:
                tabs = json.loads(urllib.request.urlopen('http://127.0.0.1:%d/json' % port, timeout=2).read())
                target = next(t for t in tabs if t['type'] == 'page'); break
            except Exception: time.sleep(0.2)
        if not target: sys.exit('Could not connect to headless Chrome.')
        cdp = CDP(WS('127.0.0.1', port, target['webSocketDebuggerUrl'].split(str(port), 1)[1]))
        for m in ('Page.enable', 'Runtime.enable', 'Network.enable'): cdp.call(m)
        cdp.call('Emulation.setDeviceMetricsOverride', width=w, height=h, deviceScaleFactor=1, mobile=False)
        cdp.call('Page.addScriptToEvaluateOnNewDocument', source=CHECK_JS)
        cdp.call('Page.navigate', url=url)
        for _ in range(200):
            time.sleep(0.2)
            if cdp.js('!!(window.Reveal && Reveal.isReady && Reveal.isReady())'): break
        else:
            sys.exit('Reveal never became ready at %s. Is Reveal.initialize() called and are the CDN files reachable?' % url)
        time.sleep(a.settle)

        def shot(name, hh, vv, ff):
            cdp.js('Reveal.slide(%d,%d,%d)' % (hh, vv, ff)); time.sleep(a.settle)
            data = cdp.call('Page.captureScreenshot', format='png')['data']
            open(os.path.join(out, name), 'wb').write(base64.b64decode(data))

        slides = cdp.js('Reveal.getSlides().map(function(s){var i=Reveal.getIndices(s);return {h:i.h,v:i.v||0,id:s.id||""}})')
        nslides = len(slides)
        for s in slides:
            hh, vv, key = s['h'], s['v'], 's%d-%d' % (s['h'], s['v'])
            shot(key + '.png', hh, vv, -1)
            steps = cdp.js('(function(){var n=0;while(n<12&&Reveal.nextFragment())n++;return n})()')
            for i in range(steps): shot('%s-step%d.png' % (key, i + 1), hh, vv, i)
            cdp.js('Reveal.slide(%d,%d,99)' % (hh, vv)); time.sleep(0.4)          # fully built
            issues = cdp.js('window.__checkSlide(Reveal.getCurrentSlide())')
            print('#/%d/%d %-22s %s' % (hh, vv, s['id'] or '(no id)', 'ok' if not issues else ''))
            for i in issues: print('    -', i); problems += 1
        for ev in cdp.events:
            if ev['method'] == 'Runtime.exceptionThrown':
                det = ev['params']['exceptionDetails']
                warnings.append('exception: ' + (det.get('exception', {}).get('description') or det.get('text', ''))[:160])
            elif ev['method'] == 'Network.loadingFailed' and not ev['params'].get('canceled'):
                warnings.append('request failed: ' + ev['params'].get('errorText', ''))
            elif ev['method'] == 'Network.responseReceived' and ev['params']['response']['status'] >= 400 and 'favicon' not in ev['params']['response']['url']:
                httperrs.append('HTTP %d: %s' % (ev['params']['response']['status'], ev['params']['response']['url'][:120]))
    finally:
        chrome.terminate()
        try: chrome.wait(timeout=10)
        except Exception: chrome.kill()
        shutil.rmtree(prof, ignore_errors=True); srv.shutdown()
    for e in sorted(set(httperrs)): print('problem:', e); problems += 1
    for wmsg in sorted(set(warnings)): print('warning:', wmsg)
    print('\n%d slides, %d problems, %d warnings. Screenshots: %s' % (nslides, problems, len(set(warnings)), out))
    sys.exit(1 if problems else 0)


main()
