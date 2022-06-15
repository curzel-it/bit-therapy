//
// Pet Therapy.
//

import Foundation
import SpriteKit

public enum PetState: Equatable {
    
    case freeFall
    case smokeOut
    case drag
    case jump
    case move
    case action(action: PetAction)
    
    public var description: String {
        switch self {
        case .smokeOut: return "smokeOut"
        case .freeFall: return "freeFall"
        case .jump: return "jump"
        case .drag: return "drag"
        case .move: return "move"
        case .action(let action): return action.id
        }
    }
}
