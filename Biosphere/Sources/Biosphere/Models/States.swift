//
// Pet Therapy.
//

import Foundation

public enum EntityState: Equatable {
    
    case freeFall
    case disappearing
    case drag
    case move
    case animation(animation: EntityAnimation)
    
    public var description: String {
        switch self {
        case .disappearing: return "disappearing"
        case .freeFall: return "freeFall"
        case .drag: return "drag"
        case .move: return "move"
        case .animation(let animation): return animation.id
        }
    }
}
