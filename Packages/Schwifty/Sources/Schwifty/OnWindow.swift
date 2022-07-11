//
// Pet Therapy.
//

#if os(macOS)

import SwiftUI

extension View {
    
    public func onWindow(_ foo: @escaping (NSWindow) -> Void) -> some View {
        self.background(WindowGrabber(onWindow: foo))
    }
}

private struct WindowGrabber: NSViewRepresentable {
    
    let onWindow: (NSWindow) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.layer?.backgroundColor = .clear
        DispatchQueue.main.async {
            if let window = view.window {
                self.onWindow(window)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // ...
    }
}

#endif
