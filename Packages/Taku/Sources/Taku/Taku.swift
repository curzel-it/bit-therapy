import SwiftUI
import WebKit

public struct TakuView: View {
    @StateObject var viewModel: TakuViewModel
    
    public init(token: String) {
        // swiftlint:disable line_length
        let xxx = "57xBLe1vWlroM2zxjmp5UkpktGTQHdcQTkvRYCCyLmh2L%2BEhRT5uamjeFuyKWLqZeYd%2BXTNVjmwE7IjzfTz3s%2BT0qYzMfOY7DKHsst%2FbBw8yGj46y6kpCsBtC%2F7zy%2BKYRLEH7pfhGkSuXeusmdh3DfZfOZC%2BtNUFCubJoR1knz8%3D"
        self._viewModel = StateObject(wrappedValue: TakuViewModel(token: xxx))
    }
    
    public var body: some View {
        ZStack {
            WebView(request: viewModel.urlRequest, navigationDelegate: viewModel)
                .opacity(viewModel.isLoading ? 0 : 1)
            
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
                .opacity(viewModel.isLoading ? 1 : 0)
        }
    }
}

class TakuViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var isLoading: Bool = true
    
    let urlRequest: URLRequest
    
    init(token: String) {
        let url = URL(string: "https://ui.taku-app.com/v1/feed?tk=\(token)")
        urlRequest = URLRequest(url: url!)
        super.init()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        withAnimation {
            isLoading = false
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        return .allow
    }
}
