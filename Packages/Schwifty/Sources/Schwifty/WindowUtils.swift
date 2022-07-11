//
// Pet Therapy.
//

#if os(macOS)

import AppKit
import SwiftUI

extension NSWindow {
    
    public func show(sender: Any? = nil) {
        guard !isVisible else { return }
        NSWindowController(window: self).showWindow(sender)
    }
}

#endif
