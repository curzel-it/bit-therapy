import Foundation

public enum EntityState {
    case freeFall
    case drag
    case move
    case action(action: EntityAnimation, loops: Int?)

    public var description: String {
        switch self {
        case .freeFall: return "freeFall"
        case .drag: return "drag"
        case .move: return "move"
        case .action(let action, _): return action.id
        }
    }
}

// MARK: - Action State

public extension EntityState {
    var isAction: Bool {
        if case .action = self {
            return true
        } else {
            return false
        }
    }
}

// MARK: - State Equatable

extension EntityState: Equatable {
    public static func == (lhs: EntityState, rhs: EntityState) -> Bool {
        lhs.description == rhs.description
    }
}
