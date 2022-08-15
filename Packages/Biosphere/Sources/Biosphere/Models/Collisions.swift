//
// Pet Therapy.
//

import Squanch
import SwiftUI

public typealias Collisions = [Collision]

extension Collisions {
    
    public func contains(_ hotspot: Hotspot) -> Bool {
        first { $0.hotspot == hotspot } != nil
    }
    
    public func contains(anyOf hotspots: [Hotspot]) -> Bool {
        hotspots.first { contains($0) } != nil
    }
    
    public var nonEphemeral: Collisions {
        filter { !$0.isEphemeral }
    }
}

extension Entity {
    
    func collisions(with neighbors: [Entity]) -> Collisions {
        neighbors
            .filter { $0 != self }
            .compactMap { self.collision(with: $0) }
    }
    
    func collision(with other: Entity) -> Collision? {
        let intersection = frame.intersection(other.frame)
        guard !intersection.isNull, !intersection.isInfinite else { return nil }        
        return Collision(of: self, with: other, on: intersection)
    }
}
