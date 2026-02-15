# M-Sphere

## Kernidee
Interaktive Schneekugel als Meditations-Erfahrung.
Inspiriert von Thomas Metzingers Schneekugel-Bild, aber radikal weitergedacht.
**Nicht linear** — der Benutzer erlebt es selbst, interaktiv.

## Ablauf / Gameplay

### 1. Overlay-Menü (idle)
- Fullscreen-Overlay im ZPMA-Stil (dunkler Hintergrund, subtile Sterne)
- **"M-SPHERE"** als Titel (Impact-Font, dreistufiger Teal-Glow)
- "INTERACTIVE MEDITATION" Untertitel
- "by Jochen Hornung Dev Studios" + "jochenhornung.de"
- Einstellungen: Zeit, Gedanken-Sound, Meditations-Sound, Kohärentes Atmen
- **START**-Button (pulsierend, erst aktiv wenn Zeit gewählt)
- Tingsha-Sound bei jedem Button-Klick, Start-Chime bei Start

### 2. Schüttel-Phase (ready → shaking)
- Hinweis: "Drücke, halte und schüttle mit der Maus die Kugel." (teal)
- Benutzer **hält Maustaste gedrückt und schüttelt** (oder Touch/Gyro)
- **Gedanken-Counter** steigt von 0% → 100%
- Neon-Partikel schießen aus dem **Oberkopf des Cyborg-Mönchs**
- Je höher der Counter, desto chaotischer — Partikel pflastern den ganzen Raum zu
- **Bei 100%**: Counter-Full-Akkord (A-C#-E), Mönch komplett verdeckt
- Erst ab 100% + Maus loslassen → Meditation beginnt

### 3. Meditations-Phase (loslassen)
- Singing-Bowl-Anschlag beim Start
- Gedanken lösen sich langsam auf, Mönch wird wieder sichtbar
- Mönch löst sich dann **mit den Gedanken zusammen auf** (glitchend, rostend)
- Linear bis zum Ende: `alpha = 1 - progress`

### 4. Verführung / Rückfall
- Während der Meditation: **subtile Reize** versuchen den Benutzer zum Schütteln zu verleiten
- Wenn der Benutzer nachgibt → **Timer reset**, Counter steigt wieder
- Rückfall-Sound: 3x dissonante Sawtooth-Oszillatoren (200–600 Hz)
- **Die Verführungen** (basierend auf Aufmerksamkeits-Forschung):
  1. **Curiosity Gap**: Schimmern am Kugelrand
  2. **Pseudo-Notification**: Rotes Badge
  3. **Kugel zuckt**: Motorische Versuchung
  4. **Sound-Impuls**: Einzelner Ping-Ton
  5. **Neon-Blitz**: Greller Partikel quer durchs Bild
- **Timing**: Anfangs ~8s, später 20–40s (seltener aber subtiler)

### 5. Ende (Leere)
- **0–5s**: Stille, leere Kugel
- **5–10s**: "Du bist das Wasser" blendet ein (Georgia serif, mehrschichtiger blau-weißer Glow)
- Verbesserte End-Glocke (6 Obertöne, 6s Nachhall)
- **35s+**: Partikel kehren langsam aus der Mitte zurück (Symbol: ewiger Kreislauf)
- **45s+**: Dezenter "klick"-Hinweis zum Neustart
- Klick → zurück zum Overlay-Menü (`selectedDurationIdx` wird zurückgesetzt)

## Sound-Design

### Wählbare Gedanken-Sounds (Schüttel-Phase)
- **Rauschen**: Bandpass-gefiltertes White Noise (Lautstärke folgt shakeIntensity)
- **Synapsen** (Default): 12 pooled Mikro-Ping-Oszillatoren (400–4000 Hz), rapid-fire
- **Stimmen**: 5 verstimmte Triangle-Oszillatoren im Sprachbereich (180–540 Hz) mit Vibrato
- **Metallisch**: 4 inharmonische Teiltöne (Basis 280 Hz, Ratios 1/2.32/3.86/5.13) mit AM

### Wählbare Meditations-Sounds
- **Drone**: 72 Hz Grundton + 108 Hz Quinte (Sinus)
- **Klangschale** (Default): Singing-Bowl-Partials (220 Hz, Ratios 1/2.71/5.41/8.56/12.24) mit Schwebung
- **Tanpura**: Sa-Pa-Sa-Drone (60 Hz, Triangle+Sinus) mit Jivari-Buzz (Sawtooth durch Lowpass)
- **Binaural**: 200 Hz links / 204 Hz rechts → 4 Hz Theta-Beat (StereoPanner)

### Interaction-Sounds
- **Tingsha**: Zwei leicht verstimmte hohe Sinus-Töne (2637/2673 Hz, 1.8s Decay) — bei Menü-Klicks
- **Start-Chime**: Aufsteigender Dreiklang G-C-E (392/523/659 Hz) — bei Start
- **Counter-Full**: A-C#-E Akkord (440/554/659 Hz) — bei 100% Gedanken
- **Tempel-Gong**: Tiefer Gong (72 Hz Basis, 5 inharmonische Partials mit Shimmer-Partnern, 12s Decay) — bei Meditationsstart UND -ende
- **Rückfall**: 3x dissonante Sawtooth (200–600 Hz, 0.4s)

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
- **Rendering**: 2D Canvas + Three.js Offscreen-Rendering für 3D-Modell
- **Input**: Maus (nur bei gedrückter Taste), Touch, Device-Gyroscope
- **States**: `idle` (Menü) → `ready` → `shaking` → `meditating` → `done`
- **Kugel**: Radiale Gradienten für Wasser, Glasrand, Glanzpunkt, Kaustiken
- **Responsive**: Füllt ganzen Viewport, Kugel = 70% der kleineren Achse

### Overlay-Menü (idle-State)
- **Stil**: ZPMA-inspiriert (Fullscreen Canvas-Overlay, nicht HTML)
- **Font**: Impact / "Arial Black" für Titel, monospace für Rest
- **Titel-Glow**: 3 Schichten — weicher Teal-Schein (blur 60) → mittlerer (blur 25) → heller Kern (blur 8)
- **Farb-Palette**: bg=#0a1628, primary=#1a3a5c, secondary=#3a6080, teal=#2abfbf, light=#f0ece6
- **Kein Default**: `selectedDurationIdx = -1`, erst klicken aktiviert START
- **Reihenfolge**: Titel → Untertitel → Credits → MEDITATIONSZEIT → GEDANKEN-SOUND → MEDITATIONS-SOUND → KOHÄRENTES ATMEN → TIMER ANZEIGEN → START
- **Hit-Detection**: `menuButtons`-Objekt mit timer/shake/meditation/breathing/timerToggle/start
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
- **HTTP-Server nötig**: `python3 -m http.server 8092` im Kugel-Ordner

### Rendering-Reihenfolge in frame()
1. Hintergrund (Farbshift je State)
2. Sterne
3. Kugel (Wasser, Glasrand, Glanzpunkt)
4. Kaustiken (geclippt)
5. **Mönch** (3D-Modell, via drawModel3D) — nicht im idle-State
6. **Partikel** (ÜBER dem Mönch — verdecken ihn bei vollem Counter)
7. **Overlay-Menü** (nur idle) / Hint-Text (nur ready) / Timer / Done-Effekte
8. Vignette, Rückfall-Flash, Counter-Ring

### Shake Detection
- **Maus**: Nur bei `mouseDown=true` — Bewegung ohne Klick wird ignoriert
- **Touch**: touchmove-Distanz
- **Device Motion**: Accelerometer, Schwelle >12
- `shakeAccum` → `shakeIntensity` (0–1), Decay 0.3/Frame

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
- **meditating**: Startet voll sichtbar, löst sich linear auf (`alpha = 1 - progress`). Ab 30% Glitch + Rost-Overlay (Alpha multipliziert mit Model-Alpha)
- **done**: Nicht sichtbar, "Du bist das Wasser" erscheint

### Atmen (Breathing)
- **Zwei Modi**: Kohärent (5.5s ein / 5.5s aus) und Beruhigend (4s ein / 6s aus)
- **Asymmetrische Welle**: Piecewise Sine für glatte Übergänge bei unterschiedlichen Ein-/Ausatem-Dauern
- **Auswahl**: Im Overlay-Menü als Settings-Row (Aus / Kohärent 5.5:5.5 / Beruhigend 4:6)
- **Default**: Kohärent (`breathingMode = 1`)
- **Kugel-Radius**: Oszilliert ±2.5% mit der Atem-Welle
- **Nebel**: Nur Cyan (#2abfbf), nur außerhalb der Kugel (Clip-Mask), 3 Gradient-Schichten + 5 Strähnen
- **State**: `BREATHING_MODES[]`, `BREATHING_TIMING[]`, `breathingMode` (0/1/2)

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
- Mönch verschwindet nicht durch Alpha-Reduktion, sondern wird von Partikeln **verdeckt**
- Mönch löst sich in Meditation linear auf (kein Einblend-Delay)
- Rost-Overlay-Alpha multipliziert mit Model-Alpha (verschwindet gemeinsam)
- "Du bist das Wasser" als Schluss-Erkenntnis mit Glow-Effekt
- Sound-Presets wählbar (4 Shake + 4 Meditation)
- Interaction-Sounds für alle wichtigen Übergänge

## Offene Fragen / Nächste Schritte
- Partikel-Formen variieren (nicht nur Kreise — Icons, Symbole?)
- Mobile-Optimierung testen (Gyro, Touch-Verhalten)
- Wasser-Visualisierung im Done-State verbessern
