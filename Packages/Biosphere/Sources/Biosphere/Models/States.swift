//
// Pet Therapy.
//

import Foundation

public enum EntityState: Equatable {
    
    case freeFall
    case disappearing
    case drag
    case move
    case animation(animation: EntityAnimation, loops: Int?)
    
    public var description: String {
        switch self {
        case .disappearing: return "disappearing"
        case .freeFall: return "freeFall"
        case .drag: return "drag"
        case .move: return "move"
        case .animation(let animation, _): return animation.id
        }
    }
}

// MARK: - Animation State

extension EntityState {
    
    public var isAnimation: Bool {
        if case .animation = self {
            return true
        } else {
            return false
        }
    }
}
