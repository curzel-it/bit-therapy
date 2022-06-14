//
// Pet Therapy.
//

import SwiftUI

public enum Spacing: CGFloat {
    case xxl = 48
    case xl = 32
    case lg = 24
    case md = 16
    case sm = 8
    case xs = 4
    case zero = 0
}

extension View {
    
    public func padding(_ spacing: Spacing) -> some View {
        modifier(SpacingMod(edges: .all, spacing: spacing))
    }
    
    public func padding(_ edges: Edge.Set, _ spacing: Spacing) -> some View {
        modifier(SpacingMod(edges: edges, spacing: spacing))
    }
}

private struct SpacingMod: ViewModifier {
    
    let edges: Edge.Set
    let spacing: Spacing?
    
    func body(content: Content) -> some View {
        if let value = spacing?.rawValue {
            content.padding(edges, value)
        } else {
            content
        }
    }
}
