# WebKit Bug Report: AudioContext.resume() unreliable in WKWebView on iOS

**Product**: WebKit / Safari / WKWebView
**Platform**: iOS 18+, iPadOS 18+
**Component**: Web Audio API
**Related Bugs**: #206695, #202846, #273511, #281566, #281955, #291892

---

## Summary

`AudioContext.resume()` called within a valid user gesture (touchstart/click event handler) frequently fails to transition the AudioContext from `"suspended"` to `"running"` on iOS. The context remains suspended for 10-30 seconds before eventually transitioning, making real-time audio feedback impossible.

This affects both Safari and WKWebView (app://localhost scheme).

## Steps to Reproduce

1. Create a web app with Web Audio API
2. Create AudioContext on first user touch (inside touchstart handler)
3. Call `audioCtx.resume()` — returns a Promise
4. Immediately try to play audio (oscillator or buffer source)
5. Audio does not play. `audioCtx.state` remains `"suspended"`
6. After 10-30 seconds and additional user touches, audio suddenly starts working

## Expected Behavior

`AudioContext.resume()` should transition to `"running"` immediately when called inside a user gesture handler, as specified in the Web Audio API spec.

## Actual Behavior

- `resume()` Promise resolves but `state` stays `"suspended"` or transitions to non-standard `"interrupted"`
- Audio playback is silently swallowed
- Eventually (10-30s later, after multiple user interactions) the context starts working
- The non-standard `"interrupted"` state (WebKit Bug #206695) is not in the Web Audio spec and breaks standard state-checking code

## Workarounds Attempted (in our production app M-Sphere)

All of these are unreliable:

```javascript
// 1. Silent buffer trick — sometimes works, sometimes doesn't
const buf = audioCtx.createBuffer(1, 1, audioCtx.sampleRate);
const src = audioCtx.createBufferSource();
src.buffer = buf;
src.connect(audioCtx.destination);
src.start(0);

// 2. Aggressive resume on every touch — helps but not 100%
canvas.addEventListener('touchstart', () => {
  audioCtx.resume();
}, { once: false });

// 3. suspend() then resume() with delay — WKWebView background recovery
audioCtx.suspend().then(() => {
  setTimeout(() => audioCtx.resume(), 200);
});

// 4. onstatechange auto-recovery — runs outside gesture, gets ignored
audioCtx.onstatechange = () => {
  if (audioCtx.state !== 'running') audioCtx.resume();
};
```

None of these reliably ensure audio works on first touch.

## Impact

- **M-Sphere** (meditation app, App Store): Users expect sound when they tap "Start Meditation". Sound arrives 10-30 seconds late or not at all
- **Any web app** using Web Audio for UI feedback, games, music apps
- Developers resort to `<audio>` elements as fallback, losing Web Audio capabilities

## Environment

- iOS 18.3.2, iPhone 15 Pro
- Safari 18.3
- WKWebView with `app://localhost` URL scheme
- AudioContext created with `{ latencyHint: 'interactive' }`

## Suggested Fix

`AudioContext.resume()` called inside a user gesture event handler should:
1. Synchronously set `state` to `"running"` (or at minimum, within the same microtask)
2. Never transition to the non-standard `"interrupted"` state — use `"suspended"` instead
3. Honor the user gesture regardless of previous `suspend()` calls or background/foreground transitions

---

**Reporter**: Jochen Hornung (de.jochenhornung.msphere)
**App**: M-Sphere — Interactive Meditation (App Store, TestFlight)
**Reproducible**: Always (on iOS), Never (on Chrome/Firefox)
