// 
// Pet Therapy.
// 

import SwiftUI

#if os(macOS)
import AppKit

extension View {
    
    public func hosted() -> NSHostingView<Self> {
        NSHostingView(rootView: self)
    }
}
#else
import UIKit

extension View {
    
    public func hosted() -> UIHostingController<Self> {
        UIHostingController(rootView: self)
    }
}
#endif
