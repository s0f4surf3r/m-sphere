import SwiftUI
import WebKit
import SafariServices
import UniformTypeIdentifiers

// MARK: - Local file server via custom URL scheme
class LocalFileSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: any WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else {
            urlSchemeTask.didFailWithError(URLError(.badURL))
            return
        }

        var path = url.path
        if path.isEmpty || path == "/" { path = "/index.html" }

        let filePath = Bundle.main.bundlePath + "/Web" + path

        guard let data = FileManager.default.contents(atPath: filePath) else {
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(Data())
            urlSchemeTask.didFinish()
            return
        }

        let mimeType = Self.mimeType(for: filePath)
        let headers: [String: String] = [
            "Content-Type": mimeType,
            "Content-Length": "\(data.count)",
            "Access-Control-Allow-Origin": "*",
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headers)!
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: any WKURLSchemeTask) {}

    static func mimeType(for path: String) -> String {
        let ext = (path as NSString).pathExtension.lowercased()
        switch ext {
        case "html": return "text/html; charset=utf-8"
        case "js", "mjs": return "application/javascript"
        case "css": return "text/css"
        case "json": return "application/json"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "gif": return "image/gif"
        case "svg": return "image/svg+xml"
        case "ico": return "image/x-icon"
        case "glb": return "model/gltf-binary"
        case "gltf": return "model/gltf+json"
        case "m4a": return "audio/mp4"
        case "mp3": return "audio/mpeg"
        case "wav": return "audio/wav"
        case "ogg": return "audio/ogg"
        case "wasm": return "application/wasm"
        case "webp": return "image/webp"
        default: return "application/octet-stream"
        }
    }
}

// MARK: - WKWebView wrapper
struct ContentView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        // Serve local files via app:// scheme
        config.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "app")

        // Inject native app flag
        let nativeScript = WKUserScript(source: """
            window.__nativeApp = true;
            window.__stripAffiliateLinks = true;
            """, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(nativeScript)

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = true
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        #if DEBUG
        webView.isInspectable = true
        #endif

        context.coordinator.webView = webView
        webView.load(URLRequest(url: URL(string: "app://localhost/index.html")!))

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    // MARK: - Coordinator
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        weak var webView: WKWebView?

        // Bewegungssensor-Zugriff (Schütteln) — nur nach expliziter Zustimmung, kein Auto-Grant
        func webView(_ webView: WKWebView,
                     requestDeviceOrientationAndMotionPermissionFor origin: WKSecurityOrigin,
                     initiatedByFrame frame: WKFrameInfo,
                     decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            guard let root = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first?.rootViewController else {
                decisionHandler(.deny)
                return
            }
            let isGerman = Locale.current.language.languageCode?.identifier == "de"
            let alert = UIAlertController(
                title: isGerman ? "Bewegungssensor" : "Motion Sensor",
                message: isGerman
                    ? "M-Sphere nutzt die Bewegungssensoren deines Geräts, um das Schütteln der Kugel zu erkennen."
                    : "M-Sphere uses your device's motion sensors to detect shaking the globe.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: isGerman ? "Erlauben" : "Allow", style: .default) { _ in
                decisionHandler(.grant)
            })
            alert.addAction(UIAlertAction(title: isGerman ? "Nicht erlauben" : "Don't Allow", style: .cancel) { _ in
                decisionHandler(.deny)
            })
            root.present(alert, animated: true)
        }

        // window.open() — öffnet externe Links in SFSafariViewController
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                openExternal(url)
            }
            return nil
        }

        // <a href> Klicks — externe URLs abfangen
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            // app:// bleibt in der App, alles andere (http/https) → SFSafariViewController
            if url.scheme == "app" {
                decisionHandler(.allow)
            } else if url.scheme == "http" || url.scheme == "https" {
                decisionHandler(.cancel)
                openExternal(url)
            } else {
                decisionHandler(.allow)
            }
        }

        private func openExternal(_ url: URL) {
            let safari = SFSafariViewController(url: url)
            safari.preferredControlTintColor = UIColor(red: 0.145, green: 0.635, blue: 0.635, alpha: 1) // teal
            if let root = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first?.rootViewController {
                root.present(safari, animated: true)
            }
        }
    }
}
