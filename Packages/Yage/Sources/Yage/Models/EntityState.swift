import Foundation

public enum EntityState {
    case freeFall
    case drag
    case move
    case action(action: EntityAction, loops: Int?)
    
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

extension EntityState {
    public var isAction: Bool {
        if case .action = self {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Action

public protocol EntityAction {
    var id: String { get }
    var chance: Double { get }
    var facingDirection: CGVector? { get }
    var requiredLoops: Int? { get }
    func frame(for entity: Entity) -> CGRect
}

// MARK: - State Equatable

extension EntityState: Equatable {
    public static func == (lhs: EntityState, rhs: EntityState) -> Bool {
        lhs.description == rhs.description
    }
}
