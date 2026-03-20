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

## 🚀 Phase 1 — App Store (WKWebView)

– [x] App-Name: M-Sphere
– [x] App Icon 1024×1024
– [x] Externe Links → SFSafariViewController
– [x] AudioContext „interrupted" Bug (WebKit #263627) — Workaround via suspend→delay→resume
– [x] Backend: Vercel → Scaleway Functions (Paris, DSGVO-konform)
– [x] @vercel/blob → Scaleway Object Storage (temporäre Bild-Uploads)
– [ ] Submit

## 🔧 Phase 2 — Polishing

– [ ] Haptic Feedback (UIFeedbackGenerator)
– [ ] iPad-Optimierung (Landscape-Layout)
– [ ] Push-Notifications (APNs + UNUserNotificationCenter)
– [ ] Audio-Dateiname prüfen: `dubistdaswasser_zoe.m4a` vs `dubistdaswasserzoe.m4a`
– [ ] Gemini Free Tier klären (oder Fallback einbauen)
– [ ] Mehrere Custom-Modelle pro User — oder nur eins?

## 💰 Phase 3 — Monetisierung

– [ ] StoreKit IAP (JS↔Swift-Bridge, StoreKit 2)
– [ ] Was soll kaufbar sein? (Dein Ich? Premium-Sounds? Face Swap Upgrade?)

## 💡 Someday

– [ ] MSphereNative in den Store
– [ ] Vision Pro (visionOS Volume/Window)
– [ ] Apple Watch (eigenes SwiftUI-Target)
