# M-Sphere

## Kernidee
Interaktive Schneekugel als Meditations-Erfahrung.
Inspiriert von Thomas Metzingers Schneekugel-Bild, aber radikal weitergedacht.
**Nicht linear** — der Benutzer erlebt es selbst, interaktiv.

## Ablauf / Gameplay

### 1. Overlay-Menü (idle)
- Fullscreen-Overlay im ZPMA-Stil (dunkler Hintergrund, subtile Sterne)
- **"M-SPHERE"** als Titel (SF Pro Display, dreistufiger Teal-Glow, verstärkte Opacities)
- "INTERACTIVE MEDITATION" Untertitel
- "by Jochen Hornung Dev Studios" + klickbarer Link "jochenhornung.de"
- Einstellungen: Meditationszeit, Gedanken-Sound, Meditations-Sound, Gedankenmodus, Atmen, Timer-Anzeige
- **"Klicke hier um zu starten"** in Accent-Farbe (pulsierend, erst aktiv wenn Zeit gewählt)
- **"Wähle eine Meditationszeit"** in #f4a842 (warm orange, font-weight 700) wenn keine Zeit gewählt
- **MEDITATIONSZEIT-Label** wird ebenfalls #f4a842 wenn keine Zeit gewählt
- Tingsha-Sound bei jedem Button-Klick (kein Sound bei Start-Klick)
- ESC-Taste kehrt aus jedem State zum Menü zurück

### 2. Schüttel-Phase (ready → shaking)
- Hinweis: "Drücke, halte und schüttle mit der Maus die Kugel." (teal)
- Benutzer **hält Maustaste gedrückt und schüttelt** (oder Touch/Gyro)
- **Gedanken-Counter** steigt von 0% → 100% (Rate: 0.55)
- Neon-Partikel schießen aus dem **Oberkopf des Cyborg-Mönchs**
- Je höher der Counter, desto chaotischer — Partikel pflastern den ganzen Raum zu
- **Ganzer Bildschirm wackelt** beim Schütteln (ctx.translate auf gesamten Canvas-Inhalt, Offset 45/30)
- **Bei 100%**: Ring wechselt von Rot zu **Gold** mit Glow + **"Du darfst jetzt loslassen ..."** Text
- Gold-Flash (weißer Blitz) beim Erreichen von 100%
- Erst ab 100% + Maus loslassen → Tempel-Gong → Meditation beginnt

### 3. Meditations-Phase (loslassen)
- **Tempel-Gong** beim Start (tiefer 72 Hz Gong mit Shimmer)
- Gedanken lösen sich langsam auf, Mönch wird wieder sichtbar
- Mönch löst sich dann **mit den Gedanken zusammen auf** (glitchend, rostend)
- Linear bis zum Ende: `alpha = 1 - progress`

### 4. Verführung / Rückfall
- Während der Meditation: **subtile Reize** versuchen den Benutzer zum Schütteln zu verleiten
- Wenn der Benutzer nachgibt → **Timer reset**, Counter steigt wieder, roter Flash
- **Die Verführungen** (basierend auf Aufmerksamkeits-Forschung):
  1. **Curiosity Gap**: Schimmern am Kugelrand
  2. **Pseudo-Notification**: Rotes Badge
  3. **Kugel zuckt**: Motorische Versuchung
  4. **Sound-Impuls**: Einzelner Ping-Ton
  5. **Neon-Blitz**: Greller Partikel quer durchs Bild
- **Timing**: Anfangs ~8s, später 20–40s (seltener aber subtiler)

### 5. Ende (Leere)
- **0–4s**: Stille, leere Kugel, Partikel sofort unsichtbar (medAlpha=0)
- **4s**: "Du bist das Wasser" Text beginnt einzufaden (Georgia serif, mehrschichtiger blau-weißer Glow)
- **4.5s**: Voice startet (`dubistdaswasser_kind.m4a` für DE, `dubistdaswasser.m4a` für EN)
- **Tempel-Gong** auch am Ende (gleicher Sound wie bei Start)
- **35s+**: Rebirth-Partikel spawnen oben, fallen mit Gravitation (0.003), prallen an Kugelwand ab — ewiger Kreislauf
- **45s+**: "Zurück ins Menü" + "♡ Unterstützen ♡" Button
- Klick → zurück zum Overlay-Menü (`selectedDurationIdx` wird zurückgesetzt)

## Sound-Design

### Wählbare Gedanken-Sounds (Schüttel-Phase)
- **Rauschen** (Default): Bandpass-gefiltertes White Noise (Lautstärke folgt shakeIntensity)
- **Synapsen**: 12 pooled Mikro-Ping-Oszillatoren (400–4000 Hz), rapid-fire
- **Stimmen**: 5 verstimmte Triangle-Oszillatoren im Sprachbereich (180–540 Hz) mit Vibrato
- **Metallisch**: 4 inharmonische Teiltöne (Basis 280 Hz, Ratios 1/2.32/3.86/5.13) mit AM

### Wählbare Meditations-Sounds
- **Drone**: 72 Hz Grundton + 108 Hz Quinte (Sinus)
- **Klangschale**: Singing-Bowl-Partials (220 Hz, Ratios 1/2.71/5.41/8.56/12.24) mit Schwebung
- **Tanpura**: Sa-Pa-Sa-Drone (60 Hz, Triangle+Sinus) mit Jivari-Buzz (Sawtooth durch Lowpass)
- **Tanpura2** (Default): Gleicher Sa-Pa-Sa-Drone wie Tanpura, aber **ohne Buzz/Rauschen** — klarerer, ruhigerer Klang
- **Binaural**: 200 Hz links / 204 Hz rechts → 4 Hz Theta-Beat (StereoPanner)

### Interaction-Sounds
- **Tingsha**: Zwei leicht verstimmte hohe Sinus-Töne (2637/2673 Hz, 1.8s Decay) — bei Menü-Klicks
- **Tempel-Gong**: Tiefer Gong (72 Hz Basis, 5 inharmonische Partials mit Shimmer-Partnern, 12s Decay) — bei Meditationsstart UND -ende
- **Voice**: `dubistdaswasser_kind.m4a` (Levi, DE default) / `dubistdaswasser.m4a` (EN) / `dubistdaswasser_zoe.m4a` (Zoe Easter Egg) — bei 4.5s Done

### Gemeinsame Sounds
- **Meditation**: Gedanken-Noise löst sich immer auf (unabhängig vom Shake-Modus)
- **Meditations-Envelope**: Sanftes Ein-/Ausblenden (12% Ramp an Anfang/Ende)

## Die Vision — Drei innere Phasen

### Das goldene Ego
- In der Mitte: **Cyborg-Mönch** (3D-Modell) — das westliche Ego, Spiritualität als Konsum
- Neon-Partikel = Gedankensucht, Dopamin-Gier, "Craving"

### Der Entzug
- Mönch **glitcht, bekommt Rost-Overlay**, wird zunehmend unsichtbar
- Neon-Gedanken werden **grau und aschig**
- Eckhart Tolle: "Tod im Leben" — das Ego wehrt sich

### Die Auflösung
- Mönch und Gedanken lösen sich **gemeinsam linear auf**
- Was bleibt: **klares, weites, stilles Wasser**
- Erkenntnis: "Du bist das Wasser"

## Philosophische Referenzen
- **Thomas Metzinger**: Schneekugel-Metapher, Bewusstseinsforschung
- **Eckhart Tolle**: "Tod im Leben", Ego-Auflösung
- **Buddhismus**: Craving, Loslassen, Nicht-Selbst (Anatta)
- **Wu Wei** (Daoismus): Nicht-Tun als höchstes Handeln

## Technische Umsetzung
- **Name**: M-Sphere (ehemals "Kugel")
- **Datei**: `kugel.html` (Single-File-Webapp, `<script type="module">`)
- **Repo**: https://github.com/s0f4surf3r/m-sphere (public, GitHub Pages)
- **Live**: https://s0f4surf3r.github.io/m-sphere/kugel.html
- **Rendering**: 2D Canvas + Three.js Offscreen-Rendering für 3D-Modell
- **Input**: Maus (nur bei gedrückter Taste), Touch, Device-Gyroscope
- **States**: `idle` (Menü) → `ready` → `shaking` → `meditating` → `done`
- **Kugel**: Radiale Gradienten für Wasser, Glasrand, Glanzpunkt, Kaustiken
- **Responsive**: Füllt ganzen Viewport, Kugel = 70% der kleineren Achse

### Overlay-Menü (idle-State)
- **Stil**: ZPMA-inspiriert (Fullscreen Canvas-Overlay, nicht HTML)
- **Font**: `-apple-system, "SF Pro Display", "Helvetica Neue"` weight 900 für Titel, "Courier New" monospace für Settings
- **Titel-Glow**: 3 Schichten — weicher Teal-Schein (blur 60, alpha 0.5/0.2) → mittlerer (blur 30, alpha 0.8/0.3) → heller Kern mit Drop-Shadow
- **Farb-Palette**: bg=#0a1628, primary=#1a3a5c, secondary=#3a6080, teal=#2abfbf, accent=#e86a7a, light=#f0ece6, hint=#f4a842, gold=#ffd700
- **Text-Opacities**: Labels 0.95, nicht-ausgewählte Buttons 0.9, Credits 0.9, jochenhornung.de 0.75(teal), Button-Borders 0.5
- **Kein Default**: `selectedDurationIdx = -1`, erst klicken aktiviert START
- **Reihenfolge**: Titel → Untertitel → Credits → MEDITATIONSZEIT → GEDANKEN-SOUND → MEDITATIONS-SOUND → GEDANKENMODUS → ATMEN → TIMER ANZEIGEN → Klicke hier um zu starten
- **Hit-Detection**: `menuButtons`-Objekt mit timer/shake/meditation/thoughtMode/breathing/timerToggle/start/link
- **Sterne**: 40 pseudozufällige Punkte mit Puls-Animation

### 3D-Modell-Integration
- **Three.js v0.170.0** via importmap (CDN jsdelivr)
- **Modell**: `japanese_monk_cyborg_sitting.glb` — Cyborg-Mönch (Sketchfab, Romain Brunas)
- **Offscreen Canvas**: WebGLRenderer (alpha:true, ACES tonemap, sRGB output, exposure 1.8), Render-Größe r*1.8
- **Mobile Display**: Mönch-Bild wird 1.4× skaliert (statt 1.0×) damit er tiefer sitzt wie auf Desktop
- **drawModel3D(cx, cy, r, alpha, glitchOffset, rustAmount)**: Zentrale Funktion
- **Kamera**: PerspectiveCamera(32°, 1:1), Position (0, 0.8, 5.0), Blick auf (0, 0.3, 0)
- **Lighting** (Studio-Setup):
  - Key: DirectionalLight (#ffeedd, 3.5) von oben-links-vorne
  - Fill: DirectionalLight (#ddeeff, 1.5) von rechts
  - Rim: DirectionalLight (#aaccff, 2.0) von hinten (Kontur-Kanten)
  - Aura: PointLight (#ffc880, 1.0) von unten
  - Hemisphere: (#c8d8f0 / #443322, 1.2) Himmel/Boden
  - Ambient: (#404050, 0.8)
- **Rost-Lighting**: Intensitäten sinken mit rustAmount (warm→kalt/dunkel)
- **Fallback**: Kein Statue-Fallback, nur teal Lade-Ring während GLB lädt
- **HTTP-Server nötig** (lokal): `python3 -m http.server 8092` im Kugel-Ordner

### Rendering-Reihenfolge in frame()
1. Hintergrund (Farbshift je State)
2. **ctx.translate(offsetX, offsetY)** — gesamter Inhalt wackelt beim Schütteln
3. Sterne
4. Kugel (Wasser, Glasrand, Glanzpunkt)
5. Kaustiken (geclippt)
6. **Mönch** (3D-Modell, via drawModel3D) — nicht im idle/done-State
7. **Partikel** (ÜBER dem Mönch — verdecken ihn bei vollem Counter)
8. **Mobile Mönch-Overlay** (35% Alpha, über Partikeln — damit Mönch auf Mobile sichtbar bleibt)
9. **Overlay-Menü** (nur idle) / Hint-Text (nur ready) / Timer / Done-Effekte
10. Vignette, Rückfall-Flash, Gold-Flash
11. **Atem-Nebel** (Cyan, nur außerhalb der Kugel)
12. **Counter-Ring** (rot, voll opak — NACH Atem-Nebel damit Rot konstant bleibt)
13. **ctx.restore()** — Schüttel-Translate aufheben

### Shake Detection
- **Maus**: Nur bei `mouseDown=true` — Bewegung ohne Klick wird ignoriert
- **Touch**: touchmove-Distanz
- **Device Motion**: Accelerometer, Schwelle >12
- `shakeAccum` → `shakeIntensity` (0–1), Decay 0.3/Frame, Counter-Rate 0.55 (Desktop) / 0.7 (Mobile)
- **Mobile**: Schwelle 30 (statt 80), touchScale 3.0, Füllzeit ~2.4s
- **Meditationsstart**: shakeAccum + shakeIntensity werden auf 0 resetet

### Partikel (Gedanken)
- **Spawn**: Aus dem Scheitel des Mönchs (`cy - r * 0.28 - r * 0.05`), bei Schweben2/3/4 zusätzlich 35% aus zufälligen Positionen in der Kugel
- **Spawn-Rate**: `shakeIntensity * 12` (Desktop) + `counter/20` Bonus / Mobile: `2 + counter * 0.15`
- **Desktop-Cap**: 3500 Partikel, **Mobile-Cap**: 800 Partikel
- **Decay**: Desktop 0.00015–0.0005, Mobile 0.00003–0.0001
- **10 Neon-Farben**, Glow per RadialGradient, Spawn-Blitz (weißer Kern, 4 Frames)
- **Meditation**: Brownsche Bewegung (0.15→0 linear), Reibung (0.99→0.97 linear), verblassen mit sqrt-Kurve (`Math.pow(1-progress, 0.5)`), Farben → Aschgrau
- **Kugelwand**: Harte Wand, Partikel prallen ab. Desktop: 0.95r, Mobile: 0.88r. Dämpfung 0.6/0.2
- **Gedankenmodus** (7 interne Modi, 4 sichtbar):
  - **Schweben2** (idx=0, AUSGEBLENDET): Ohne Kollision, nur Brownsche Bewegung
  - **Schweben2-alt** (idx=1, EINGEFROREN): gl.readPixels-Kollision + Sog
  - **Schweben3-alt** (idx=2, EINGEFROREN): Wie idx=1
  - **Schweben mit Sog** (idx=3): Kollision + Sog zum Mönch (progress*0.01)
  - **Sinken** (idx=4): Gravitation 0.003 (Shaking) / 0.002 (Meditation)
  - **Reflektieren** (idx=5): Wie Schweben, Rand-Reflexion immer aktiv
  - **Schweben** (idx=6, DEFAULT): Kollision ohne Sog, bester Modus
  - **Sichtbar im Menü**: `THOUGHT_MODES_VISIBLE = [6, 3, 4, 5]`
  - **Migration**: Gespeicherter idx=0 wird automatisch auf idx=6 umgeleitet
- **Mönch-Kollisionsmaske**: 48×48 Uint8Array, Update alle 30 Frames. Chrome: gl.readPixels. Safari: ctx.getImageData vom Haupt-Canvas (Brightness >180). Partikel werden radial zur nächsten freien Stelle geschoben.
- **Physik**: Desktop leichte Reibung (0.995), Mobile stärkere Reibung (0.98) + Gravitation (0.002)

### Mönch-Verhalten je State
- **idle**: Nicht sichtbar (Overlay-Menü verdeckt alles)
- **ready**: Voll sichtbar (alpha=1), goldene Atem-Aura pulsiert
- **shaking**: Voll sichtbar, aber Partikel stapeln sich darüber und verdecken ihn
- **meditating**: Startet voll sichtbar, löst sich linear auf (`alpha = 1 - progress`). Ab 30% subtiler Glitch (Offset *3) + Rost-Overlay (Alpha multipliziert mit Model-Alpha)
- **done**: Nicht sichtbar, "Du bist das Wasser" erscheint

### Atmen (Breathing)
- **Drei Optionen**: Aus / Kohärent (5.5s ein / 5.5s aus) / Beruhigend (4s ein / 6s aus)
- **Asymmetrische Welle**: Piecewise Sine für glatte Übergänge bei unterschiedlichen Ein-/Ausatem-Dauern
- **Auswahl**: Im Overlay-Menü als Settings-Row (Aus / Kohärent 5.5:5.5 / Beruhigend 4:6)
- **Default**: Kohärent (`breathingMode = 1`)
- **Kugel-Radius**: Oszilliert ±2.5% mit der Atem-Welle
- **Nebel**: Nur Cyan (#2abfbf), direkt an Kugelrand (clipR=r+2), 3 Gradient-Schichten + 5 Strähnen
- **State**: `BREATHING_MODES[]`, `BREATHING_TIMING[]`, `breathingMode` (0/1/2)

### Timer-Anzeige
- **Toggle**: Im Menü schaltbar (TIMER ANZEIGEN AN/AUS)
- **Default**: Aus (`timerVisible = false`)
- **Anzeige**: Uhrzeitanzeige unter der Kugel (optional)
- **Counter-Ring**: Rot (255,70,90) bis 99%, bei 100% Gold (255,215,0) mit Glow + "Du darfst jetzt loslassen ..."
- **Position**: `rFixed - 3` (leicht innerhalb der Glaskante)
- **rFixed**: Counter-Ring nutzt fixen Radius, bewegt sich nicht mit Atem-Animation

### Weitere Effekte
- **Gold-Flash**: Weißer Blitz beim Erreichen von 100% Counter (decay 0.9)
- **Rückfall-Flash**: Roter Lichtring (alpha 0.6, decay 0.92)
- **Bildschirm-Shake**: Ganzer Canvas-Inhalt wackelt (ctx.translate, Offset ±22.5/±15 bei voller Intensität)
- **Trail-Effekt**: Halbtransparenter BG-Layer bei heftigem Schütteln
- **Vignette**: Dunkle Ecken (40% schwarz am Rand)
- **Hintergrund-Farbshift**: Warm/rötlich (shaking) → kühl/bläulich (meditating) → tiefblau (done)
- **Glasreflex-Animation**: Wandert langsam über die Kugel
- **Sterne**: 60 Punkte, dimmen beim Schütteln, heller im Done-State
- **Kugel-Glas**: Fast transparent in der Mitte, Lichtbrechung am Rand, scharfe Glaskante

## Entscheidungen
- 2D Canvas + Three.js Hybrid — alle 2D-Effekte bleiben, nur Mönch ist 3D
- Overlay-Menü statt Inline-UI — Fokus auf die Kugel nach dem Start
- Schütteln nur bei gedrückter Maus — verhindert versehentliches Auslösen
- Timer muss explizit im Menü gewählt werden bevor START möglich ist
- Timer-Anzeige optional (Toggle im Menü)
- Mönch verschwindet nicht durch Alpha-Reduktion, sondern wird von Partikeln **verdeckt**
- Mönch löst sich in Meditation linear auf (kein Einblend-Delay)
- Rost-Overlay-Alpha multipliziert mit Model-Alpha (verschwindet gemeinsam)
- "Du bist das Wasser" als Schluss-Erkenntnis mit Glow-Effekt
- Sound-Presets wählbar (4 Shake + 5 Meditation), Defaults: Rauschen + Tanpura2
- Tempel-Gong bei Start UND Ende der Meditation (kein Counter-Full-Sound, kein Start-Chime, kein Rückfall-Sound)
- Rückfall nur visuell (roter Flash), kein Sound — weniger störend
- Atem-Nebel nur Cyan, kein Magenta — subtiler, meditativer
- Zwei Atem-Modi für verschiedene Präferenzen (symmetrisch vs. beruhigend)
- Mönch-Glitch sehr subtil (Offset *3 statt *15) — sanftes Zittern statt wildem Wackeln
- Counter-Rate 0.55 (moderates Schütteln)
- shakeAccum/shakeIntensity werden bei Meditationsstart auf 0 gesetzt (verhindert falsche Rückfall-Trigger)
- Voice über AudioContext statt HTML Audio Element (umgeht Autoplay-Block)
- AudioContext mit `latencyHint: 'interactive'` + `resume()` an kritischen Stellen
- **iOS Stumm-Schalter**: `navigator.audioSession.type = 'playback'` (Safari 16.4+) + Silent-Audio-Fallback → Sound spielt auch bei stummgeschaltetem iPhone
- ESC-Taste als universeller Abbruch → zurück ins Menü
- Ring wechselt bei 100% zu Gold + "Du darfst jetzt loslassen ..." als Feedback
- Gedankenmodus: 7 interne Modi, 4 sichtbar. Default: Schweben (idx=6, mit Kollision)
- **Schweben2-alt (idx=1) + Schweben3-alt (idx=2) sind EINGEFROREN** — nicht verändern ohne ausdrückliche User-Anweisung
- **Schweben2 (idx=0) ist AUSGEBLENDET** — nur versteckt, nicht gelöscht
- Mönch-Silhouetten-Abstoßung: Pixelgenaue 48×48 Kollisionsmaske, Safari-Fallback via Haupt-Canvas
- DPR-Skalierung: cW/cH globale CSS-Dimensionen, dpr=1 (deaktiviert für Performance)
- Meditation: Alles linear (Verblassen sqrt-Kurve, Reibung, Brownsche Bewegung, Sog)
- Counter-Rate: Desktop 0.55, Mobile 0.35

## Persistenz (localStorage)
Folgende Keys werden gespeichert:
- `msphere_lang` — Sprache (de/en)
- `msphere_breathing` — Atemrhythmus (0-4)
- `msphere_medsound` — Meditations-Sound (0-6)
- `msphere_thought` — Gedankenmodus (idx)
- `msphere_flow` — Gedankenfluss (0-5)
- `msphere_timer` — Timer-Anzeige (true/false)
- `msphere_distraction` — Ablenkungen (0/1)
- `msphere_faceswap` — Face-Swap-Bild (data URL)
- `msphere_facemode` — Face-Modus (idx)
- `msphere_faceswap_last` — Letzte Faceswap-Nutzung (Timestamp, für Rate-Limiting)
- **NICHT gespeichert**: Meditationszeit (wird jedes Mal neu gewählt)

## Easter Eggs
- **Levi**: Swipe-Links auf "M-SPHERE" Titel → `easterEggVoice = 'levi'`, Text "In Liebe von deinem Papa!"
- **Zoe**: 3× Tap auf "M-SPHERE" Titel → `easterEggVoice = 'zoe'`, Text "Für Zoe ♡"
- **Levi-Voice ist DE-Default**: `dubistdaswasser_kind.m4a` spielt immer für DE (nicht nur im Easter-Egg)

## Face Swap
- **API**: Replicate (Modell `278a81e...`), Proxy via Vercel Serverless (`/Users/joho21/Projekte/m-sphere-api/api/faceswap.js`)
- **Rate-Limiting**: 1× pro Tag pro IP (Server-seitig in-memory Map) + Client-seitig localStorage
- **Labels**: Aus / Mediathek / Kamera / Laden (einheitlich auf allen Geräten)
- **Kamera-Bug-Fix**: Nach Chrome-Permission-Dialog wird `menuExpanded.face = true` gesetzt
- **Menü-Verhalten**: Einklapp-Menüs bleiben nach Auswahl offen, schließen nur bei anderer Kategorie oder manuellem Zuklappen
- **TODO**: Bezahlfunktion für Face Swap (Zoe-Modus soll kostenlos bleiben)

## Sicherungs-Tags
- `v1.0-pre-payment` — Snapshot vor Payment-Feature (alle Fixes fertig)

## Offene Fragen / Nächste Schritte
- **Payment-Feature** für Face Swap (Stripe?) — Zoe-Modus bleibt kostenlos
- Partikel-Formen variieren (nicht nur Kreise — Icons, Symbole?)
- Wasser-Visualisierung im Done-State verbessern
