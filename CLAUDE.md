# Projekt Kugel

## Kernidee
Interaktive Schneekugel als Meditations-Erfahrung.
Inspiriert von Thomas Metzingers Schneekugel-Bild, aber radikal weitergedacht.
**Nicht linear** — der Benutzer erlebt es selbst, interaktiv.

## Ablauf / Gameplay

### 1. Schüttel-Phase (aktiv)
- Benutzer schüttelt: **Maus bewegen, Finger/Touch, oder ganzes Device (Gyro)**
- **Gedanken-Counter** steigt von 0% → 100%
- Neon-Partikel schießen vulkanartig aus dem Kopf der goldenen Statue
- Je höher der Counter, desto chaotischer, lauter, greller
- **Bei 100%**: Totales Chaos — die goldene Figur ist **gar nicht mehr sichtbar**
- Erst ab 100% kann die Meditations-Phase beginnen

### 2. Meditations-Phase (loslassen)
- Benutzer **hört auf** zu schütteln → Timer startet
- **Dauer einstellbar**: 1, 5, 10, 20, 30 Minuten
- Gedanken lösen sich langsam auf im Raum
- Figur wird kurz wieder **sichtbar** (durch weniger Partikel)
- Aber Figur löst sich dann **mit den Gedanken zusammen auf**
- Rostend, glitchend, zerfallend → bis nichts mehr da ist

### 3. Verführung / Rückfall
- Während der Meditation: **subtile Reize** versuchen den Benutzer zum Schütteln zu verleiten
- Wenn der Benutzer nachgibt und wieder schüttelt → **Timer reset**, Counter steigt wieder
- = Genau wie echte Meditation: der Geist will zurück ins Drama
- **Die Verführungen** (basierend auf Aufmerksamkeits-Forschung):
  1. **Curiosity Gap** (stärkster Trigger): Ein kurzes Schimmern am Kugelrand, ein Schatten der sich bewegt — "was wäre, wenn du nochmal schüttelst?" Dopamin feuert bei Ungewissheit, nicht bei Belohnung
  2. **Pseudo-Notification**: Rotes Badge blinkt kurz auf, wie eine ungelesene Nachricht. Rot aktiviert evolutionäre Dringlichkeits-Reaktion
  3. **Die Kugel zuckt**: Subtile motorische Versuchung — die Kugel vibriert leicht, als ob sie geschüttelt werden *will*. Appelliert an motorisches Ritual (Pull-to-Refresh-Reflex)
  4. **Zeigarnik-Stups**: Die goldene Statue schimmert kurz durch die Partikel — "unfinished business", das Ego zeigt sich nochmal. Der Drang, hinzuschauen
  5. **Sound-Impuls**: Ein einzelner, fast unhörbarer Ton durchbricht die Stille — wie ein Gedanke, der sagt "schau mal". Unterbrechungs-basiertes Design
  6. **Neon-Blitz**: Ein einzelner greller Partikel schießt quer durchs Bild — FOMO, als ob man etwas verpasst
- **Timing**: Anfangs häufig (alle 20-30s), werden seltener aber **subtiler und wirksamer** je weiter die Meditation fortschreitet — genau wie echte Gedanken

### 4. Ende (Leere)
- Nach Ablauf der gewählten Zeit: **Kugel ist leer**
- Klares, stilles Wasser
- Keine Figur, keine Gedanken
- Erkenntnis: Du warst nie die Figur. Du bist das Wasser.

## Sound-Design
- **Schüttel-Phase**: Gedankenflut-Sound, chaotisch, laut, überwältigend
- **Meditations-Beginn**: Dramatisch, unheimlich (der "Tod im Leben")
- **Verlauf**: Wird immer weiter, leichter, offener
- **Ende**: Stille oder ein sehr minimaler, weiter Klang

## Die Vision — Drei innere Phasen

### Das goldene Ego
- In der Mitte: kein bescheidener Mönch, sondern ein **goldener Götze**
- Das westliche Ego, der "Mac-Meditierer", Spiritualität als Konsum
- Narzissmus, Verliebtheit in die eigene Identität
- Statt Schneeflocken: **Neon-Blitze, bunte Süßigkeiten, grelle Icons**
- = Gedankensucht, Dopamin-Gier, "Craving" (buddhistisch)

### Der Entzug
- Loslassen fühlt sich anfangs an wie **Sterben**
- Die goldene Statue **rostet, bekommt Risse, glitcht**
- Neon-Gedanken werden **grau und aschig**
- Eckhart Tolle: "Tod im Leben" — das Ego wehrt sich

### Die Auflösung
- Statue löst sich **komplett auf** — Verschwinden, nicht Zerfall
- Gedanken verlieren Härte, Farbe, Form — sie **schmelzen**
- Alles wird eins: Gedanken waren nur **gefrorenes Wasser**
- Was bleibt: **klares, weites, stilles Wasser**

## Philosophische Referenzen
- **Thomas Metzinger**: Schneekugel-Metapher, Bewusstseinsforschung
- **Eckhart Tolle**: "Tod im Leben", Ego-Auflösung
- **Buddhismus**: Craving, Loslassen, Nicht-Selbst (Anatta)
- **Wu Wei** (Daoismus): Nicht-Tun als höchstes Handeln

## Technische Umsetzung
- **Datei**: `kugel.html` (Single-File-Webapp)
- **Rendering**: 2D Canvas (HTML5 Canvas API)
- **Input**: Maus, Touch, Device-Gyroscope
- **Timer**: Wählbar 1 / 5 / 10 / 20 / 30 Minuten
- **States**: `idle` → `shaking` → `meditating` → `done`
- **Kugel**: Radiale Gradienten für Wasser, Glasrand, Glanzpunkt (oben links)
- **Responsive**: Füllt ganzen Viewport, Kugel = 70% der kleineren Achse
- **Goldene Statue**: Stilisierte Meditationsfigur aus Gradienten (goldShine/goldLight/goldMid/goldDark), Lotussitz-Basis, Körper, Kopf, Hände, goldene Aura. Größe = 28% des Kugelradius, Position leicht unter Kugelmitte
- **Shake Detection**: Maus (mousemove-Distanz), Touch (touchmove-Distanz), Device Motion (Accelerometer, Schwelle >12). `shakeAccum` sammelt Bewegung, `shakeIntensity` (0–1) wird pro Frame berechnet mit 0.3 Decay
- **thoughtCounter**: 0–100%, steigt mit `shakeIntensity * 0.8` pro Frame. Bei 100% → State wechselt zu `meditating`
- **Neon-Partikel**: Spawnen aus dem Kopf der Statue beim Schütteln. 10 Neon-Farben. Spawn-Rate steigt mit Counter (+1 pro 25%). Langsamer Decay (0.0008–0.0023) damit viele akkumulieren. Physik: leichte Gravitation beim Schütteln, Reflexion am Kugelrand. Glow-Effekt per RadialGradient
- **Timer-Auswahl**: 5 Buttons unter der Kugel im `idle`-State: 1/5/10/20/30 Minuten. Klick/Touch wählt aus, ausgewählter Button heller. Responsive Größe (7% der kleineren Achse). Verschwindet beim Schütteln
- **Timer**: `meditationTimeLeft` zählt runter. Anzeige unter der Kugel (MM:SS), dezent weiß, wird heller je näher am Ende. Timer reset bei Rückfall (erneutes Schütteln)
- **Counter-Ring**: Pinker Bogen um die Kugel, zeigt thoughtCounter % als Kreissegment
- **Meditations-Logik**: Counter sinkt linear über die gewählte Dauer, Partikel lösen sich mit auf
- **Statue-Auflösung in Meditation**: Phase 1 (0–70%): Statue wird kurz sichtbar, beginnt zu glitchen (horizontaler Versatz, zufällig), Rost-Overlay wird stärker (Gold→Braun/Grau). Phase 2 (70–100%): komplett verschwunden. Kein sanftes Zurückkommen — die Statue zerfällt
- **Sound (Web Audio API)**: Startet bei erster Nutzer-Interaktion (Browser-Policy). Zwei Schichten:
  - *Noise*: Bandpass-gefiltertes White Noise = Gedankenrauschen. Lautstärke folgt shakeIntensity, Filter öffnet sich mit thoughtCounter (800–4800 Hz). Wird leiser und dumpfer während Meditation
  - *Drone*: Tiefer Sinuston (72 Hz) = meditativer Grundton. Blendet während Meditation ein (Peak bei 50%), dann wieder aus zum Ende
- **Verführungs-Trigger (implementiert)**: Nur aktiv während `meditating`. Intervall: anfangs ~8s, später 20–40s (seltener aber subtiler). 4 Typen:
  - *badge*: Rotes Notification-Badge oben rechts in der Kugel (blinkt kurz auf)
  - *flash*: Neon-Blitz quer durch die Kugel (FOMO)
  - *twitch*: Kugel zuckt/vibriert horizontal (motorischer Reiz)
  - *shimmer*: Subtiles weißes Schimmern am Kugelrand (Curiosity Gap)
  - *sound*: Kurzer Ping-Ton (Gedanke der anklopft)
  - Früh (0–40%): badge, flash, twitch, sound. Spät (40–100%): shimmer, sound, twitch
- **Partikel-Entsättigung**: Während Meditation werden Neon-Farben zu Aschgrau (Zielwert RGB 80,80,80). Glow wird ebenfalls schwächer. Alle Farben via `rgba()` für sauberes Alpha-Blending
- **Partikel-Meditation**: Kein Fallen, kein schnelles Verschwinden. Partikel bleiben wo sie sind (sanftes Abbremsen 0.995/Frame), verblassen LINEAR über die gesamte Meditationsdauer. Alpha = min(eigenes Life, meditations-Progress). Gedanken verströmen in den Raum und lösen sich dort auf
- **Done-State**: Klick/Touch → zurück zu `idle`. Kugel ist leer. Sanftes bläulich-klares Leuchten blendet über 3s ein. Langsamer Lichtpuls (Atmung) im Zentrum. Keine Statue, keine Partikel, keine Verführungen. Nur klares Wasser
- **Wasser-Klarheit**: Kugel-Inneres wird heller/klarer während Meditation (RGB-Werte + Alpha steigen). Im Done-State am klarsten
- **UI-Texte**: "shake" (pulsierend, über Kugel, idle), "klick" (dezent, unter Kugel, done nach 5s)

## Entscheidungen
- Nicht linear, sondern interaktiv — der Benutzer muss es selbst erleben
- 2D Canvas (nicht WebGL) — reicht für den Effekt, einfacher
- Schütteln bis 100%, dann Meditation mit Timer
- **Timer sichtbar** — MM:SS unter der Kugel, dezent
- **Timer reset bei Rückfall** — wer wieder schüttelt, fängt von vorn an
- **Counter-Ring** — pinker Bogen um die Kugel zeigt Fortschritt
- Verführungs-Mechanik: 5 psychologisch fundierte Trigger
- Erklärung/Intro kommt später

### Feinschliff (implementiert)
- **Rückfall-Flash**: Roter Lichtring um die Kugel bei Rückfall (alpha 0.6, decays mit 0.92)
- **Rückfall-Sound**: 3x dissonante Sawtooth-Oszillatoren (200–600 Hz, 0.4s decay)
- **Done-Sound**: Dreiklang-Glocke (528/660/792 Hz), gestaffelt, 3-4s decay
- **Kugel-Wackeln**: Beim Schütteln wackelt die gesamte Kugel leicht (random offset * intensity)
- **Trail-Effekt**: Beim heftigen Schütteln halbtransparenter schwarzer Layer statt hartem Clear → Partikel ziehen Spuren
- **Partikel-Größenvariation**: 15% große (5–8px), 30% winzige (1–2.5px), Rest mittel (2–5px)
- **Partikel-Schrumpfen**: Während Meditation schrumpfen Partikel sanft auf 70% (nicht aggressiv)
- **Partikel-Spawn-Bereich**: Ab 60% Counter spawnen Partikel aus dem ganzen Körper, nicht nur dem Kopf
- **Drone-Oberton**: Zweiter Sinus bei 108 Hz (Quinte), kommt ab 30% Meditation, Peak bei 60%, leiser als Grundton
- **Hintergrund-Sterne**: 60 subtile Punkte außerhalb der Kugel, twinkeln langsam (Alpha 0.03–0.18)
- **Counter-Ring-Puls**: Ring pulsiert leicht, ab 50% zusätzlicher äußerer Glow
- **Partikel-Clipping**: Partikel werden per Canvas-Clip auf Kugelinneres begrenzt (r*0.95)
- **Statue-Atem (idle)**: Goldene Aura pulsiert langsam (0.0015 Hz Sinus), Größe und Helligkeit atmen mit
- **Vignette**: Dunkle Ecken/Ränder (radial gradient, 40% schwarz am Rand) für Tiefe und Fokus
- **Lineares Verblassen**: Gedanken verblassen gleichmäßig über die gesamte Meditationsdauer — kein schneller Abbau, kein Fallen
- **Hintergrund-Farbshift**: Warm/rötlich beim Schütteln, kühl/bläulich während Meditation, tiefblau im Done-State. Subtile RGB-Verschiebung, kein hartes Umschalten
- **Glasreflex-Animation**: Glanzpunkt und Glare wandern langsam über die Kugel (0.0001 Hz Sinus), als ob sich das Licht dreht
- **Wasser-Kaustiken**: 5 sich bewegende Lichtflecken im Kugelinneren (per Clip begrenzt). Stärker sichtbar in Meditation und Done. Verschwinden beim heftigen Schütteln
- **Sterne reagieren auf State**: Dimmen beim Schütteln (Chaos überstrahlt), werden heller im Done-State (Klarheit). `starBright`-Multiplikator auf Alpha
- **Partikel-Spawn-Blitz**: Neue Partikel haben in den ersten 4 Frames einen weißen Kern (60% Alpha, 1.5x Größe). Gibt dem Moment der Gedanken-Entstehung eine visuelle Schärfe
- **Innere Glasreflexion**: Zweiter, weicher Lichtring innen am Kugelrand (r*0.92, 4% Alpha). Simuliert Lichtbrechung in echtem Glas, gibt Tiefe
- **Cursor ausgeblendet**: `cursor: none` auf Canvas — keine Ablenkung
- **Partikel-Akkumulation**: Langsamerer Decay (0.0008–0.0023) + höhere Spawn-Rate bei hohem Counter → Kugel füllt sich richtig voll bei 100%

## Offene Fragen / Nächste Schritte
- Intro/Erklärungsscreen
- Partikel-Formen variieren (nicht nur Kreise — Icons, Symbole?)
- Mobile-Optimierung testen (Gyro, Touch-Verhalten)
