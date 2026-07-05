# M-Sphere — Roadmap

## ✅ Phase 0 — Fundament

– [x] Web App live (msphere.jochenhornung.de)
– [x] iOS WKWebView App (TestFlight)
– [x] isSafari-Erkennung + Performance-Fix (WKWebView)
– [x] Pre-rendered Partikel-Sprites
– [x] „Dein Ich" — personalisierte 3D-Modelle (Gemini + Meshy)
– [x] CORS-Fix für WKWebView (Download-Proxy)
– [x] MSphereNative — SceneKit + Metal Grundstruktur
– [x] Keyboard & Gamepad Input (InputManager)

## ✅ Phase 1 — Backend & Cleanup

– [x] Backend: Vercel → Scaleway Functions (Paris, DSGVO-konform)
– [x] @vercel/blob → Scaleway Object Storage (S3, zero dependencies)
– [x] Face Swap + PayPal Code entfernt (~800 Zeilen)
– [x] API auf 5 Endpoints reduziert (nur model/*)
– [x] End-to-End-Test: "Dein Ich" über Scaleway funktioniert
– [ ] Vercel stilllegen

## 🛒 Phase 2 — StoreKit + "Dein Ich" verbessern (archiviert, siehe Phase 2.5)

– [x] StoreKit 2 IAP in WKWebView-App (JS↔Swift Bridge)
– [x] Produkt in App Store Connect angelegt (Consumable, 2×Credits, 2,99€)
– [x] Transaction-Verifizierung (on-device, StoreKit 2)
– [x] Restore Purchases
– [x] Credit-System (UserDefaults + Transaction.all)
– [x] "Dein Ich" verbessern: 3 Gemini-Varianten zur Auswahl
– [x] Minimum 2 Fotos erzwingen (frontal + seitlich)
– [x] Kostenloser Retry wenn 3D-Modell nicht gefällt
– [x] TestFlight-Build lief nach 90 Tagen ab, nie auf App Store submitted

## 🆓 Phase 2.5 — Umstellung auf komplette Free-App

– [x] Monetarisierten Stand gesichert (Git-Tag `monetarisiert-2026-07-05`)
– [x] StoreKit komplett entfernt (StoreManager.swift, JS↔Swift Bridge, .storekit-Config)
– [x] Timer-Limit (10 Min Free / Abo für unbegrenzt) entfernt — Timer immer unbegrenzt
– [x] "Dein Ich" per Feature-Flag (`DEIN_ICH_ENABLED = false`) ausgeblendet (API-Kosten Gemini+Meshy ohne Monetarisierung nicht tragbar)
– [x] Privacy Policy + App Store Metadata von IAP/Abo-Erwähnungen bereinigt
– [ ] App Store Connect: Abo "M-Sphere Standard" + IAP "Dein Ich" deaktivieren/löschen
– [ ] App Store Connect: App-Beschreibung/Screenshots/Review-Notes aktualisieren
– [ ] Build-Nummer hochzählen, neuer Build für TestFlight/Review
– [ ] App Store Submit als komplett kostenlose App

## 🔧 Phase 3 — Polishing

– [ ] Haptic Feedback (UIFeedbackGenerator)
– [ ] iPad-Optimierung (Landscape-Layout)
– [x] Audio-Dateiname geklärt: `dubistdaswasserzoe.m4a` (ohne Unterstrich)
– [ ] Gemini Free Tier klären (oder Fallback einbauen)
– [ ] Mehrere Custom-Modelle pro User — oder nur eins?

## 💡 Someday

– [ ] Onboarding-Probatorik: „Wie ist dein Nervensystem?" (Überreizt/Starre/Reguliert) → personalisiert Tempo, Partikel-Dichte, Musik
– [ ] MSphereNative in den Store
– [ ] Vision Pro (visionOS Volume/Window)
– [ ] Apple Watch (eigenes SwiftUI-Target)
