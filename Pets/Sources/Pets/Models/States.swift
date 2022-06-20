//
// Pet Therapy.
//

import Foundation
import SpriteKit

public enum PetState: Equatable {
    
    case freeFall
    case smokeBomb
    case drag
    case jump
    case move
    case animation(animation: PetAnimation)
    
    public var description: String {
        switch self {
        case .smokeBomb: return "smokeBomb"
        case .freeFall: return "freeFall"
        case .jump: return "jump"
        case .drag: return "drag"
        case .move: return "move"
        case .animation(let animation): return animation.id
        }
    }
}
