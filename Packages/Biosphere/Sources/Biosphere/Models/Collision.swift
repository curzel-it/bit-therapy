//
// Pet Therapy.
//

import Squanch
import SwiftUI

public struct Collision: Equatable {
    
    public let bodyId: String
    public let isEphemeral: Bool
    public let intersection: CGRect
    public let isOverlapping: Bool
    
    let sourceBody: CGRect
    
    init(of source: Entity, with body: Entity, on intersection: CGRect) {
        self.bodyId = body.id
        self.isEphemeral = body.isEphemeral
        self.intersection = intersection
        self.sourceBody = source.frame
        self.isOverlapping = intersection.width >= 1 && intersection.height >= 1
    }
}

extension Collision {
    
    public var hotspot: Hotspot? {
        Hotspot.allCases.first { $0.rawValue == bodyId }
    }
}

extension Collision {
    
    public enum Side {
        case top, right, bottom, left
    }
    
    public func sides() -> [Side] {
        var sides: [Side] = []
        let angle = sourceBody.center.angle(to: intersection.center)
        
        func inBetween(_ angle: CGFloat, _ pi1: CGFloat, _ pi2: CGFloat) -> Bool {
            if pi1 == 2 || pi2 == 2 || pi1 == 0 || pi2 == 0 {
                if angle == 0 || abs(angle - 2 * .pi) < 0.0001 {
                    return true
                }
            }
            return angle >= pi1 * .pi && pi2 <= pi2 * .pi
        }
        
        let intersectionEdges = intersection.corners.filter { $0.isOnEdge(of: sourceBody) }
        let touchesTop = intersectionEdges.contains { $0.y == sourceBody.maxY }
        let touchesRight = intersectionEdges.contains { $0.x == sourceBody.maxX }
        let touchesBottom = intersectionEdges.contains { $0.y == sourceBody.minY }
        let touchesLeft = intersectionEdges.contains { $0.x == sourceBody.minX }
        
        if touchesTop && inBetween(angle, 0.0, 1.0) { sides.append(.top) }
        if touchesRight && (inBetween(angle, 0.0, 0.5) || inBetween(angle, 1.5, 2.0)) { sides.append(.right) }
        if touchesBottom && inBetween(angle, 1.0, 2.0) { sides.append(.bottom) }
        if touchesLeft && inBetween(angle, 0.5, 1.5) { sides.append(.left) }
        
        return sides
    }
}

private extension CGPoint {
    
    func side(of rect: CGRect) -> Collision.Side? {
        if x == rect.minX && rect.minY < y && y < rect.maxY { return .left }
        if x == rect.maxX && rect.minY < y && y < rect.maxY { return .right }
        if y == rect.minY && rect.minX < x && x < rect.maxX { return .top }
        if y == rect.maxY && rect.minX < x && x < rect.maxX { return .bottom }
        return nil
    }
}
