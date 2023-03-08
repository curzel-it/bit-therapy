import Schwifty
import SwiftUI

enum Spacing: CGFloat {
    case xxxxl = 80
    case xxxl = 64
    case xxl = 48
    case xl = 32
    case lg = 24
    case md = 16
    case sm = 8
    case xs = 4
    case zero = 0
    case inverseMd = -16
}

extension View {
    func padding(_ spacing: Spacing) -> some View {
        modifier(SpacingMod(edges: .all, spacing: spacing))
    }

    func padding(_ edges: Edge.Set, _ spacing: Spacing) -> some View {
        modifier(SpacingMod(edges: edges, spacing: spacing))
    }

    func padding(when condition: DeviceRequirements, _ edges: Edge.Set, _ spacing: Spacing? = nil) -> some View {
        padding(when: condition, edges, spacing?.rawValue)
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
