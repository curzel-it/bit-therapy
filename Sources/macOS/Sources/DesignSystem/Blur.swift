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
private struct Blur: NSViewRepresentable {
    var style: NSVisualEffectView.Material = .hudWindow

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = style
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        view.material = style
    }
}
#else
private struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThinMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#endif
