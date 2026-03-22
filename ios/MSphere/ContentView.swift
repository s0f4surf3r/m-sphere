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
    @ObservedObject var storeManager: StoreManager

    func makeCoordinator() -> Coordinator {
        Coordinator(storeManager: storeManager)
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

        // Inject native app flag + strip affiliate links + credits
        let credits = storeManager.credits
        let nativeScript = WKUserScript(source: """
            window.__nativeApp = true;
            window.__stripAffiliateLinks = true;
            window.__deinIchCredits = \(credits);
            """, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(nativeScript)

        // Register JS→Swift message handler
        config.userContentController.add(context.coordinator, name: "msphere")

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
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
        let storeManager: StoreManager
        weak var webView: WKWebView?

        init(storeManager: StoreManager) {
            self.storeManager = storeManager
        }

        // MARK: - JS→Swift Message Handler
        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            guard message.name == "msphere",
                  let body = message.body as? [String: Any],
                  let action = body["action"] as? String else { return }

            switch action {
            case "purchase":
                Task { @MainActor in
                    let success = await storeManager.purchaseDeinIch()
                    let credits = storeManager.credits
                    let js = "window.__handlePurchaseResult(\(success), \(credits));"
                    try? await webView?.evaluateJavaScript(js)
                }
            case "useCredit":
                Task { @MainActor in
                    storeManager.useCredit()
                    let credits = storeManager.credits
                    let js = "window.__deinIchCredits = \(credits);"
                    try? await webView?.evaluateJavaScript(js)
                }
            case "restorePurchases":
                Task { @MainActor in
                    await storeManager.restorePurchases()
                    let credits = storeManager.credits
                    let js = "window.__handleRestoreResult(\(credits));"
                    try? await webView?.evaluateJavaScript(js)
                }
            case "getCredits":
                Task { @MainActor in
                    await storeManager.recalculateCredits()
                    let credits = storeManager.credits
                    let js = "window.__deinIchCredits = \(credits);"
                    try? await webView?.evaluateJavaScript(js)
                }
            default:
                break
            }
        }

        // Auto-grant DeviceMotion/Orientation permission (gyro shake)
        func webView(_ webView: WKWebView,
                     requestDeviceOrientationAndMotionPermissionFor origin: WKSecurityOrigin,
                     initiatedByFrame frame: WKFrameInfo,
                     decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            decisionHandler(.grant)
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
