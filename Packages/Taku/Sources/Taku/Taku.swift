import SwiftUI
import WebKit

public struct TakuView: View {
    @StateObject var viewModel: TakuViewModel
    
    public init(token: String) {
        // swiftlint:disable line_length
        let token = "znJfBeHgzbOegRTE/x2B4DLjhHs6bHMXTav4v/Q0LCdhr7h3wAqTC7YgqGrWdPTtWdLmgpPSV/gUkQ9UVxL/bjix47VA6bPYCozLoUscwcpDIm7jHO0wnVJEMDeyNJgM+lMzOHvdPYmMSkZcZwYLbn6FoetrsKAwmbqass0UnhU="
        let userId = "1"
        
        self._viewModel = StateObject(wrappedValue: TakuViewModel(apiToken: token, userIdentificator: userId))
    }
    
    public var body: some View {
        ZStack {
            WebView(token: viewModel.token, userId: viewModel.userId, navigationDelegate: viewModel)
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
    
    let token: String
    let userId: String
    
    init(apiToken: String, userIdentificator: String) {
        token = apiToken
        userId = userIdentificator
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
