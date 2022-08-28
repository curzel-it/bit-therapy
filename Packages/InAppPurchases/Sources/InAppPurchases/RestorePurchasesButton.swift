import DesignSystem
import Lang
import SwiftUI
import Tracking

public struct RestorePurchasesButton: View {
    
    @StateObject private var viewModel = ViewModel()
    
    public init() {
        // ...
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
    
    @Published var title: String = Lang.Settings.restorePurchases
    
    func restore() {
        animateTitle(Lang.loading)
        Task {
            let succeed = await PricingService.global.restorePurchases()
            Task { @MainActor in
                if succeed {
                    animateTitle("\(Lang.done)!")
                } else {
                    animateTitle("\(Lang.somethingWentWrong)!")
                }
                animateTitle(Lang.Settings.restorePurchases, delay: 2)
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
