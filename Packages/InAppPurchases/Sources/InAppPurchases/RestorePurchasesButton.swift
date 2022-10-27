import DesignSystem
import SwiftUI
import Tracking

public struct RestorePurchasesButton: View {    
    @StateObject private var viewModel: ViewModel
    
    public init(with lang: Lang) {
        self._viewModel = StateObject(wrappedValue: ViewModel(with: lang))
    }
    
    public var body: some View {
        Button(viewModel.title) {
            viewModel.restore()
            Tracking.didRestorePurchases()
        }
        .buttonStyle(.regular)
    }
}

private class ViewModel: ObservableObject {
    @Published var title: String
    
    private var lang: Lang
    
    init(with lang: Lang) {
        self.lang = lang
        self.title = lang.restorePurchases
    }
    
    func restore() {
        animateTitle(lang.loading)
        Task {
            let succeed = await PricingService.global.restorePurchases()
            Task { @MainActor in
                if succeed {
                    animateTitle("\(lang.done)!")
                } else {
                    animateTitle("\(lang.somethingWentWrong)!")
                }
                animateTitle(lang.restorePurchases, delay: 2)
            }
        }
    }
    
    func animateTitle(_ value: String, delay: TimeInterval=0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            withAnimation {
                self?.title = value
            }
        }
    }
}
