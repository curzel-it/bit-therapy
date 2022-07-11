//
// Pet Therapy.
//

import SwiftUI

extension Text {
    
    public func textAlign(_ align: TextAlignment) -> some View {
        modifier(TextAlignMod(align: align))
    }
}

extension Button {
    
    public func textAlign(_ align: TextAlignment) -> some View {
        modifier(TextAlignMod(align: align))
    }
}

private struct TextAlignMod: ViewModifier {
    
    let align: TextAlignment
    
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            switch align {
            case .leading:
                content.multilineTextAlignment(align)
                Spacer(minLength: 0)
            case .center:
                content.multilineTextAlignment(align)
            case .trailing:
                Spacer(minLength: 0)
                content.multilineTextAlignment(align)
            }
        }
    }
}
