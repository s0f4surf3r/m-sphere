# M-Sphere

## Probatorik-Potenzial
Onboarding-Probatorik denkbar: „Wie ist dein Nervensystem gerade?" (Überreizt/Starre/Reguliert) → personalisiert die Meditation (Tempo, Partikel-Dichte, Musik). Muster → globale CLAUDE.md (`## Probatorik-Muster`)


Interaktive Schneekugel als Meditations-Erfahrung.
Inspiriert von Metzingers Schneekugel-Metapher: Goldener Mönch = Ego, Neon-Partikel = Craving, Auflösung = „Du bist das Wasser".

- **Repo**: https://github.com/s0f4surf3r/m-sphere (public)
- **Live**: https://msphere.jochenhornung.de/ (GitHub Pages)
- **States**: `idle` → `choosing` → `ready` → `shaking` → `meditating` → `done`
- **Farb-Palette**: bg=#000, surface=#1e3232, mid=#1e5a5a, teal=#25a2a2, yellow=#edd457, coral=#ed7070

---

## Web App (`index.html`)

Single-File-Webapp, 2D Canvas + Three.js Hybrid.

- **Datei**: `index.html` im Kugel-Ordner (Single-File, `<script type="module">`)
- **Rendering**: 2D Canvas (Partikel, Kugel, UI) + Three.js Offscreen (3D-Mönch)
- **Deploy**: `git push origin main` → GitHub Pages, live in Sekunden
- **Lokal testen**: `python3 -m http.server 8092` im Kugel-Ordner
- **Three.js v0.170.0** via importmap (CDN jsdelivr)

### NICHT ÄNDERN ohne ausdrückliche Anweisung

- **Schweben2-alt (idx=1) + Schweben3-alt (idx=2) sind EINGEFROREN**
- **Schweben2 (idx=0) ist AUSGEBLENDET** — nur versteckt, nicht gelöscht
- Partikel-Caps: Desktop 3500, Mobile 800
- DPR-Skalierung: idle/choosing dpr=devicePixelRatio(max 2), andere States dpr=1
- iOS Stumm-Schalter: `navigator.audioSession.type = 'playback'`
- Voice über AudioContext (nicht HTML Audio Element)

### Key Design-Entscheidungen

- Schütteln nur bei gedrückter Maus (verhindert versehentliches Auslösen)
- Mönch wird von Partikeln **verdeckt** (nicht durch Alpha reduziert)
- Meditation: Mönch + Partikel lösen sich **gemeinsam linear** auf
- Tempel-Gong bei Start UND Ende (kein anderer Sound bei Transitions)
- Rückfall nur visuell (roter Flash), kein Sound
- Counter-Rate: Desktop 0.55, Mobile 0.35
- Partikel-Glow: Pre-rendered Sprites (drawImage statt createRadialGradient)
- isSafari-Erkennung: `/AppleWebKit/i` ohne `/Chrome/i` (erkennt WKWebView korrekt)
- Safari-Browser (nicht App): `_topFactor = 2.0` statt 2.2 (Safari hat Bottom-Adressleiste → größeres innerHeight)

### 3D-Modelle (Web / DRACO)

- **Modelle**: `model_male_compressed.glb` (351 KB), `model_female_compressed.glb` (352 KB) — Meshy AI, DRACO
- **Easter-Modelle**: `meshy_zoe_compressed.glb`, `meshy_jochen_compressed.glb`
- **Gold-Glow**: Alle Modelle `color ×(1.3, 1.1, 0.7)` + Emissive `#503810` 8%
- **Komprimierung**: `npx @gltf-transform/cli draco input.glb output.glb`
- **Kollisionsmaske (Web)**: 48×48 Uint8Array, `gl.readPixels` Alpha-Kanal, Update alle 30 Frames

### Easter Eggs

- **Levi**: Swipe-Links auf Titel → Voice `dubistdaswasser_kind.m4a` (ist auch DE-Default)
- **Zoe**: 3× Tap auf Titel ODER Keyboard „ZOE" → eigenes Modell (`meshy_zoe_compressed.glb`), Voice `dubistdaswasserzoe.m4a`
- **Jochen**: 4× Tap ODER Keyboard „JOCHEN" → eigenes Modell (`meshy_jochen_compressed.glb`)
- 3×/4× Tap: 3. Tap wartet 400ms auf möglichen 4. Tap

### Persistenz (localStorage)

Keys: `msphere_lang`, `msphere_breathing`, `msphere_medsound`, `msphere_thought`, `msphere_flow`, `msphere_timer`, `msphere_distraction`, `msphere_model`, `msphere_rotate`, `msphere_dei_task`

**NICHT gespeichert**: Meditationszeit, Easter-Egg-Modus

### „Dein Ich" — Personalisierte 3D-Modelle

Pipeline:
1. **Gemini API** (`gemini-2.5-flash-image`) → Foto(s) → Meditationsbild (1-2 Fotos, 512px JPEG)
2. **Meshy Image-to-3D** (`meshy-6`, `should_texture: false`, 100k Polys) → 30 Credits, ~2-3 Min
3. **Meshy Remesh** (100k Polys) → 5 Credits, GLB ~3 MB → gespeichert in IndexedDB

Erkenntnisse:
- `should_texture: false` Pflicht (weiße Silhouette)
- Remesh reduziert ~37 MB → ~3 MB
- Task-ID in `msphere_dei_task` → Polling überlebt App-Kill
- Bei Fehler: `localStorage.removeItem('msphere_dei_task')` in ALLEN catch-Blöcken (verhindert Stuck-State)

---

## iOS App — WKWebView (`ios/MSphere`)

SwiftUI-Wrapper um die Web App.

- **Bundle-ID**: `de.jochenhornung.msphere`
- **Team**: VA8S75SSYF, Automatic Signing
- **Architektur**: SwiftUI + WKWebView, URL-Schema `app://localhost/`
- **Native-Flag**: `window.__nativeApp = true` per WKUserScript injiziert
- **Web-Assets**: Symlinks in `ios/Web/` → Elternverzeichnis, Build-Script `cp -RL`
- **Build**: `xcodegen generate` → `xcodebuild -scheme MSphere ...`
- **Simulator**: `xcrun simctl install booted ...` / `xcrun simctl launch booted de.jochenhornung.msphere`

---

## iOS/Mac App — Native (`ios/MSphereNative`)

Vollständige Neu-Implementierung in Swift ohne WebView.

- **Bundle-ID**: `de.jochenhornung.msphere.native`
- **Architektur**: SwiftUI + SceneKit + Metal (Partikel-Engine via Metal Shader)
- **3D-Rendering**: GLTFKit2 — lädt `_nodraco.glb` Varianten (GLTFKit2 unterstützt kein DRACO)
- **Audio**: AVAudioEngine (nicht WebAudio) — eigene Synth-Engine für Shake/Meditation/Gong
- **Input**: `InputManager` (GameController.framework + SwiftUI onKeyPress)
- **Aktueller Build**: 1.0 (13) — Keyboard/Gamepad-Input implementiert

### Input-Mapping (InputManager)

| Keyboard | Gamepad | Aktion |
|----------|---------|--------|
| Enter | A | Bestätigen (state-abhängig) |
| ESC | Menu | Zurück → idle |
| ← → Pfeiltasten | D-Pad / L-Stick | Menü-Navigation |
| Space (halten) | L-Stick Magnitude / R-Trigger | Kugel schütteln |
| — | Stick loslassen | Wenn Counter = 100% → Meditation |

D-Pad und linker Stick haben immer dieselbe Funktion.
Bei Non-Touch-Input (Keyboard/Gamepad): Meditation startet **automatisch** wenn Counter = 100%.

### Modelle (Native / nodraco)

- `model_male_compressed_nodraco.glb`, `model_female_compressed_nodraco.glb`
- `meshy_zoe_compressed_nodraco.glb`, `meshy_jochen_compressed_nodraco.glb`
- Nodraco-Versionen aus DRACO-GLBs erzeugen: `npx @gltf-transform/cli optimize --no-draco input.glb output_nodraco.glb`

### Build & Distribution

```bash
cd /Users/joho21/Projekte/Kugel/ios
xcodegen generate
# Simulator:
xcodebuild -scheme MSphereNative -destination 'id=<UDID>' build
# TestFlight:
xcodebuild -scheme MSphereNative -destination generic/platform=iOS archive -archivePath /tmp/MSphereNative.xcarchive
xcodebuild -exportArchive -archivePath /tmp/MSphereNative.xcarchive -exportPath /tmp/out -exportOptionsPlist ExportOptions.plist
# Mac (Apple Silicon): .app aus DerivedData per AirDrop — läuft nativ ohne Installation
```

### JWT-Fix für App Store Connect API (deploy.sh)

`openssl dgst -sign` erzeugt DER-Format — JWT braucht Raw R||S (64 Bytes). Die Shell-Funktion in `deploy.sh` ist **kaputt** (401 bei API-Calls). Fix via Python:

```python
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec, utils

der_sig = key.sign(unsigned.encode(), ec.ECDSA(hashes.SHA256()))
r, s = utils.decode_dss_signature(der_sig)
raw = r.to_bytes(32, 'big') + s.to_bytes(32, 'big')
# raw → base64url → JWT signature
```

Spüra-Projekt hat die korrigierte Version — von dort kopieren wenn nötig.

Screenshot: `xcrun simctl io booted screenshot /tmp/screenshot.png`

→ Offene Aufgaben & Phasen: `ROADMAP.md`

---

## API-Backend (`/Users/joho21/Projekte/m-sphere-api/`)

Scaleway Serverless Function (Paris, DSGVO-konform) — ein Router-Handler für alle Endpoints.

- **Function-ID**: `d6076e75-d8a7-4952-a3a3-d247cf5c3ab0`
- **Namespace-ID**: `9f2c95cb-80d5-47b9-83bd-708f6d804a93` (msphere)
- **Domain**: `mspherevyfiykwu-msphere-api.functions.fnc.fr-par.scw.cloud`
- **Deploy**: `scw function deploy namespace-id=9f2c95cb-80d5-47b9-83bd-708f6d804a93 name=msphere-api runtime=node22 zip-file=<zip> region=fr-par`
- **Lokaler Dev**: `npm run dev` (Port 3002)
- **Secrets**: Env-Vars auf Scaleway Function (6 Stück: MESHY_API_KEY, GEMINI_API_KEY, S3_ACCESS_KEY, S3_SECRET_KEY, S3_BUCKET, S3_REGION)
- **Object Storage**: Bucket `msphere-tmp` (S3-kompatibel, public-read, für temporäre Meshy-Uploads)

| Endpoint | Funktion |
|----------|----------|
| `api/model/generate-image` | Fotos → Gemini → Meditationsbild |
| `api/model/generate-3d` | image_url → Meshy → task_id |
| `api/model/status` | Meshy Task-Status (Polling) |
| `api/model/remesh` | Remesh starten/Polling |
| `api/model/download` | **CORS-Proxy** — WKWebView (`app://localhost`) kann Meshy CDN nicht direkt fetchen |

---

## Offene Fragen

- Gemini Free Tier für Bilder: funktioniert aktuell, unklar wie lange
- Mehrere Custom-Modelle pro User oder nur eins?
- Audio-Dateiname prüfen: CLAUDE.md sagt `dubistdaswasser_zoe.m4a`, project.yml sagt `dubistdaswasserzoe.m4a` (ohne Unterstrich) — welches ist korrekt?
