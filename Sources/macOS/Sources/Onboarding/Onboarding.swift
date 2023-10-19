import NotAGif
import Schwifty
import SwiftUI

extension View {
    func onboardingHandler() -> some View {
        modifier(OnboardingMod())
    }
}

private struct OnboardingMod: ViewModifier {
    @AppStorage("shouldShowWelcome") var shouldShowWelcome: Bool = true
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $shouldShowWelcome, onDismiss: close) {
                VStack(spacing: .lg) {
                    Text(Lang.Onboarding.title)
                        .font(.boldTitle)
                        .multilineTextAlignment(.center)
                    Text(Lang.Onboarding.message)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    PetChilling()
                    Spacer()
                    
                    Button(Lang.ok, action: close)
                        .buttonStyle(.regular)
                        .accessibilityIdentifier("close_onboarding")
                }
                .padding()
            }
    }
    
    private func close() {
        shouldShowWelcome = false
    }
}

private struct PetChilling: View {
    let animationFrames: [ImageFrame]
    let fps: TimeInterval = 10
    
    init() {
        @Inject var assets: PetsAssetsProvider
        animationFrames = assets.images(for: "cat_blue", animation: "front")
    }
    
    var body: some View {
        
        AnimatedContent(frames: animationFrames, fps: fps) { frame in
            Image(frame: frame)
                .pixelArt()
                .frame(width: 150, height: 150)
        }
    }
}
