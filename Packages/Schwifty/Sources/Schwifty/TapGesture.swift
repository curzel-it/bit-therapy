// 
// Pet Therapy.
// 

import SwiftUI

#if os(macOS)

import AppKit

extension View {
    
    public func tappableOnInvisibleAreas() -> some View {
        self.overlay {
            Image(nsImage: NSImage())
                .resizable()
                .scaledToFill()
        }
    }
}

#endif

#if os(iOS)

import UIKit

extension View {
    
    public func tappableOnInvisibleAreas() -> some View {
        self.overlay {
            Image(uiImage: UIImage())
                .resizable()
                .scaledToFill()
        }
    }
}

#endif
