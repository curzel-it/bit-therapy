// 
// Pet Therapy.
// 

import SwiftUI

extension View {
    
    public func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
    
    public func frame(sizeOf rect: CGRect) -> some View {
        self.frame(size: rect.size)
    }
}
