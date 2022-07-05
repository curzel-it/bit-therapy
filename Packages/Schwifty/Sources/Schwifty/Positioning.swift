//
// Pet Therapy.
//

import Foundation
import SwiftUI

// MARK: - Positions

public enum Positioning {
    case leadingTop
    case leadingMiddle
    case leadingBottom
    case top
    case middle
    case bottom
    case trailingTop
    case trailingMiddle
    case trailingBottom
}

// MARK: - View Extension

extension View {
    
    public func positioned(_ align: Positioning) -> some View {
        modifier(PositioningMod(alignment: align))
    }
}

// MARK: - View Modifier

private struct PositioningMod: ViewModifier {
    
    let alignment: Positioning
    
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            if !alignment.isLeading {
                Spacer(minLength: 0)
            }
            VStack(spacing: 0) {
                if !alignment.isTop {
                    Spacer(minLength: 0)
                }
                content
                if !alignment.isBottom {
                    Spacer(minLength: 0)
                }
            }
            if !alignment.isTrailing {
                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - Utils

extension Positioning {
    
    var isLeading: Bool {
        switch self {
        case .leadingTop, .leadingMiddle, .leadingBottom: return true
        default: return false
        }
    }
    
    var isTrailing: Bool {
        switch self {
        case .trailingTop, .trailingMiddle, .trailingBottom: return true
        default: return false
        }
    }
    
    var isTop: Bool {
        switch self {
        case .top, .leadingTop, .trailingTop: return true
        default: return false
        }
    }
    
    var isBottom: Bool {
        switch self {
        case .bottom, .leadingBottom, .trailingBottom: return true
        default: return false
        }
    }
}
