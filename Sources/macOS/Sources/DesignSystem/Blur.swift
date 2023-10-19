import Schwifty
import SwiftUI

extension View {
    func tabBarBlurBackground() -> some View {
        modifier(BlurBackgroundMod())
    }
}

private struct BlurBackgroundMod: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        content
        #else
        content.background { Blur() }
        #endif
    }
}

#if !os(macOS)
private struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .regular

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#endif
