import AppKit
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let token: String
    let userId: String
    
    let navigationDelegate: WKNavigationDelegate
    
    func makeNSView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        let scriptSource = """
        window.takuConfig = {
            token: '\(token)',
            user_id: '\(userId)'
        }
        """
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        contentController.addUserScript(script)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let view = WKWebView(frame: .zero, configuration: config)
        let url = URL(string: "https://ui.taku-app.com/v1/feed")
        let urlRequest = URLRequest(url: url!)
        
        view.navigationDelegate = navigationDelegate
        view.load(urlRequest)
        return view
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // ...
    }
}
