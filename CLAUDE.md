# M-Sphere

## Kernidee
Interaktive Schneekugel als Meditations-Erfahrung.
Inspiriert von Thomas Metzingers Schneekugel-Bild, aber radikal weitergedacht.
**Nicht linear** — der Benutzer erlebt es selbst, interaktiv.

## Ablauf / Gameplay

### 1. Overlay-Menü (idle)
- Fullscreen-Overlay im ZPMA-Stil (dunkler Hintergrund, subtile Sterne)
- **"M-SPHERE"** als Titel (SF Pro Display, dreistufiger Teal-Glow)
- "INTERACTIVE MEDITATION" Untertitel
- "by Jochen Hornung Dev Studios" + klickbarer Link "jochenhornung.de"
- Einstellungen: Meditationszeit, Gedanken-Sound, Meditations-Sound, Atmen, Timer-Anzeige
- **"Klicke hier um zu starten"** in Accent-Farbe (pulsierend, erst aktiv wenn Zeit gewählt)
- **"Wähle eine Meditationszeit"** in #f4a842 (warm orange, font-weight 700) wenn keine Zeit gewählt
- Tingsha-Sound bei jedem Button-Klick (kein Sound bei Start-Klick)
- ESC-Taste kehrt aus jedem State zum Menü zurück

### 2. Schüttel-Phase (ready → shaking)
- Hinweis: "Drücke, halte und schüttle mit der Maus die Kugel." (teal)
- Benutzer **hält Maustaste gedrückt und schüttelt** (oder Touch/Gyro)
- **Gedanken-Counter** steigt von 0% → 100%
- Neon-Partikel schießen aus dem **Oberkopf des Cyborg-Mönchs**
- Je höher der Counter, desto chaotischer — Partikel pflastern den ganzen Raum zu
- **Bei 100%**: Mönch komplett verdeckt (kein Sound bei 100%)
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
- **0–5s**: Stille, leere Kugel
- **5–10s**: "Du bist das Wasser" blendet ein (Georgia serif, mehrschichtiger blau-weißer Glow) + Voice-Audio (M4A via AudioContext)
- **Tempel-Gong** auch am Ende (gleicher Sound wie bei Start)
- **Voice**: `dubistdaswasser.m4a` — wird per fetch vorgeladen, via AudioContext decodiert und abgespielt
- **35s+**: Partikel kehren langsam aus der Mitte zurück (Symbol: ewiger Kreislauf)
- **45s+**: Dezenter "klick"-Hinweis zum Neustart
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
- **Tanpura** (Default): Sa-Pa-Sa-Drone (60 Hz, Triangle+Sinus) mit Jivari-Buzz (Sawtooth durch Lowpass)
- **Binaural**: 200 Hz links / 204 Hz rechts → 4 Hz Theta-Beat (StereoPanner)

### Interaction-Sounds
- **Tingsha**: Zwei leicht verstimmte hohe Sinus-Töne (2637/2673 Hz, 1.8s Decay) — bei Menü-Klicks
- **Tempel-Gong**: Tiefer Gong (72 Hz Basis, 5 inharmonische Partials mit Shimmer-Partnern, 12s Decay) — bei Meditationsstart UND -ende
- **Voice**: `dubistdaswasser.m4a` — bei "Du bist das Wasser" Einblendung (nach 5s Done)

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
- **Titel-Glow**: 3 Schichten — weicher Teal-Schein (blur 60) → mittlerer (blur 30) → heller Kern mit Drop-Shadow
- **Farb-Palette**: bg=#0a1628, primary=#1a3a5c, secondary=#3a6080, teal=#2abfbf, accent=#e86a7a, light=#f0ece6, hint=#f4a842
- **Kein Default**: `selectedDurationIdx = -1`, erst klicken aktiviert START
- **Reihenfolge**: Titel → Untertitel → Credits → MEDITATIONSZEIT → GEDANKEN-SOUND → MEDITATIONS-SOUND → ATMEN → TIMER ANZEIGEN → Klicke hier um zu starten
- **Hit-Detection**: `menuButtons`-Objekt mit timer/shake/meditation/breathing/timerToggle/start/link
- **Sterne**: 40 pseudozufällige Punkte mit Puls-Animation

### 3D-Modell-Integration
- **Three.js v0.170.0** via importmap (CDN jsdelivr)
- **Modell**: `japanese_monk_cyborg_sitting.glb` — Cyborg-Mönch (Sketchfab, Romain Brunas)
- **Offscreen Canvas**: WebGLRenderer (alpha:true, ACES tonemap, sRGB output, exposure 1.8), Render-Größe r*1.8
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
2. Sterne
3. Kugel (Wasser, Glasrand, Glanzpunkt)
4. Kaustiken (geclippt)
5. **Mönch** (3D-Modell, via drawModel3D) — nicht im idle-State
6. **Partikel** (ÜBER dem Mönch — verdecken ihn bei vollem Counter)
7. **Overlay-Menü** (nur idle) / Hint-Text (nur ready) / Timer / Done-Effekte
8. Vignette, Rückfall-Flash, Counter-Ring, Atem-Nebel

### Shake Detection
- **Maus**: Nur bei `mouseDown=true` — Bewegung ohne Klick wird ignoriert
- **Touch**: touchmove-Distanz
- **Device Motion**: Accelerometer, Schwelle >12
- `shakeAccum` → `shakeIntensity` (0–1), Decay 0.3/Frame, Counter-Rate 0.6
- **Meditationsstart**: shakeAccum + shakeIntensity werden auf 0 resetet

### Partikel (Gedanken)
- **Spawn**: Aus dem Oberkopf des Mönchs (`cy - r * 0.28`), ab 60% Counter auch aus dem Körper
- **Spawn-Rate**: `shakeIntensity * 15` + Bonus pro 10% Counter
- **Decay**: Sehr langsam (0.0003–0.0011) — akkumulieren und pflastern den Raum zu
- **10 Neon-Farben**, Glow per RadialGradient, Spawn-Blitz (weißer Kern, 4 Frames)
- **Meditation**: Abbremsen (0.995/Frame), verblassen linear mit Timer, Farben → Aschgrau
- **Physik**: Leichte Gravitation, Reflexion am Kugelrand (r*0.92)

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
- **Nebel**: Nur Cyan (#2abfbf), nur außerhalb der Kugel (Donut-Clip-Mask), 3 Gradient-Schichten + 5 Strähnen
- **State**: `BREATHING_MODES[]`, `BREATHING_TIMING[]`, `breathingMode` (0/1/2)

### Timer-Anzeige
- **Toggle**: Im Menü schaltbar (TIMER ANZEIGEN AN/AUS)
- **Default**: Aus (`timerVisible = false`)
- **Anzeige**: Uhrzeitanzeige unter der Kugel (optional)
- **Counter-Ring**: Immer sichtbar, direkt auf Kugelrand (`rFixed`, kein Offset), doppelt dick (lineWidth 3+pulse*2 / Glow 12)
- **rFixed**: Counter-Ring nutzt fixen Radius, bewegt sich nicht mit Atem-Animation

### Weitere Effekte
- **Rückfall-Flash**: Roter Lichtring (alpha 0.6, decay 0.92)
- **Kugel-Wackeln**: Random offset * shakeIntensity
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
- Sound-Presets wählbar (4 Shake + 4 Meditation), Defaults: Synapsen + Tanpura
- Tempel-Gong bei Start UND Ende der Meditation (kein Counter-Full-Sound, kein Start-Chime, kein Rückfall-Sound)
- Rückfall nur visuell (roter Flash), kein Sound — weniger störend
- Atem-Nebel nur Cyan, kein Magenta — subtiler, meditativer
- Zwei Atem-Modi für verschiedene Präferenzen (symmetrisch vs. beruhigend)
- Mönch-Glitch sehr subtil (Offset *3 statt *15) — sanftes Zittern statt wildem Wackeln
- Counter-Rate 0.4 (langsamer füllen, längeres Schütteln nötig)
- shakeAccum/shakeIntensity werden bei Meditationsstart auf 0 gesetzt (verhindert falsche Rückfall-Trigger)
- Voice über AudioContext statt HTML Audio Element (umgeht Autoplay-Block)
- AudioContext mit `latencyHint: 'interactive'` + `resume()` an kritischen Stellen
- ESC-Taste als universeller Abbruch → zurück ins Menü

## Offene Fragen / Nächste Schritte
- Partikel-Formen variieren (nicht nur Kreise — Icons, Symbole?)
- Mobile-Optimierung testen (Gyro, Touch-Verhalten)
- Wasser-Visualisierung im Done-State verbessern
