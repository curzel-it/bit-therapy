import DesktopKit

extension AutoRespawn {
    
    static func isCompatible(with entity: Entity) -> Bool {
        guard entity.capability(for: BounceOffLateralCollisions.self) != nil else { return false }
        guard entity.capability(for: Gravity.self) != nil else { return false }
        return true
    }
}
