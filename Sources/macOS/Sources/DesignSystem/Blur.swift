import Schwifty
import SwiftUI

extension View {
    func backgroundBlur() -> some View {
        modifier(BlurBackgroundMod())
    }
}

private struct BlurBackgroundMod: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        if #available(macOS 12.0, *) {
            content.background { Blur() }
        } else {
            ZStack {
                Blur()
                content
            }
        }
        #else
        content.background { Blur() }
        #endif
    }
}

#if os(macOS)
private typealias Blur = EmptyView
#else
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
