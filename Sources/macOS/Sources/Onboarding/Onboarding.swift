import SwiftUI

extension View {
    func onboardingHandler() -> some View {
        modifier(OnboardingMod())
    }
}

private struct OnboardingMod: ViewModifier {
    @AppStorage("shouldShowWelcome3") var shouldShowWelcome: Bool = true
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $shouldShowWelcome, onDismiss: close) {
                VStack(spacing: .lg) {
                    Text(Lang.Onboarding.title)
                        .font(.largeBoldTitle)
                        .multilineTextAlignment(.center)
                    Text(Lang.Onboarding.message)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(Lang.ok, action: close)
                        .buttonStyle(.regular)
                }
                .padding()
            }
    }
    
    private func close() {
        shouldShowWelcome = false
    }
}
