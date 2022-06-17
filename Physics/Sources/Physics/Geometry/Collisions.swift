//
// Pet Therapy.
//

import Squanch
import SwiftUI

public typealias Collisions = [Collision]

extension Collisions {
    
    public func contains(_ hotspot: Hotspot) -> Bool {
        with(hotspot) != nil
    }
    
    public func with(_ hotspot: Hotspot) -> Collision? {
        first { $0.bodyId == hotspot.rawValue }
    }
    
    public var nonEphemeral: Collisions {
        filter { !$0.isEphemeral }
    }
}

public struct Collision: Equatable {

    public let bodyId: String
    public let isEphemeral: Bool
    public let intersection: CGRect
    
    init(with body: PhysicsEntity, in rect: CGRect) {
        self.bodyId = body.id
        self.isEphemeral = body.isEphemeral
        self.intersection = rect
    }
    
    public init(bodyId: String, intersection: CGRect, isEphemeral: Bool = false) {
        self.bodyId = bodyId
        self.isEphemeral = isEphemeral
        self.intersection = intersection
    }
}

extension PhysicsEntity {
    
    func collisions(with neighbors: [PhysicsEntity]) -> Collisions {
        neighbors
            .filter { $0 != self }
            .compactMap { self.collision(with: $0) }
    }
    
    func collision(with other: PhysicsEntity) -> Collision? {
        let intersection = frame.intersection(other.frame)
        if !intersection.isNull && !intersection.isInfinite {
            return Collision(with: other, in: intersection)
        }
        return nil
    }
}
