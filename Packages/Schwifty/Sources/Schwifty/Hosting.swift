// 
// Pet Therapy.
// 

import SwiftUI

extension View {
    
    public func hosted() -> NSHostingView<Self> {
        NSHostingView(rootView: self)
    }
}
