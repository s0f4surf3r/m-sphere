# M-Sphere — Roadmap

## ✅ Phase 0 — Fundament

– [x] Web App live (msphere.jochenhornung.de)
– [x] iOS WKWebView App (TestFlight Build 13)
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

## 🛒 Phase 2 — StoreKit + "Dein Ich" verbessern

– [x] StoreKit 2 IAP in WKWebView-App (JS↔Swift Bridge)
– [x] Produkt in App Store Connect angelegt (Consumable, 2×Credits, 2,99€)
– [x] Transaction-Verifizierung (on-device, StoreKit 2)
– [x] Restore Purchases
– [x] Credit-System (UserDefaults + Transaction.all)
– [ ] "Dein Ich" verbessern: 3 Gemini-Varianten zur Auswahl
– [ ] Minimum 2 Fotos erzwingen (frontal + seitlich)
– [ ] Kostenloser Retry wenn 3D-Modell nicht gefällt
– [ ] App Store Submit (Screenshots, Beschreibung, Review)

## 🔧 Phase 3 — Polishing

– [ ] Haptic Feedback (UIFeedbackGenerator)
– [ ] iPad-Optimierung (Landscape-Layout)
– [ ] Audio-Dateiname prüfen: `dubistdaswasser_zoe.m4a` vs `dubistdaswasserzoe.m4a`
– [ ] Gemini Free Tier klären (oder Fallback einbauen)
– [ ] Mehrere Custom-Modelle pro User — oder nur eins?

## 💡 Someday

– [ ] MSphereNative in den Store
– [ ] Vision Pro (visionOS Volume/Window)
– [ ] Apple Watch (eigenes SwiftUI-Target)
