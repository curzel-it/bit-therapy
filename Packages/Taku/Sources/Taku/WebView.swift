import AppKit
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let request: URLRequest
    let navigationDelegate: WKNavigationDelegate
    
    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = navigationDelegate
        view.load(request)
        return view
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // ...
    }
}
