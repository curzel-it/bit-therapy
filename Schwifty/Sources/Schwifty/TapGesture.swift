// 
// Pet Therapy.
// 

import SwiftUI

extension View {
    
    public func tappableOnInvisibleAreas() -> some View {
        self.overlay {
            Image(nsImage: NSImage())
                .resizable()
                .scaledToFill()
        }
    }
}
