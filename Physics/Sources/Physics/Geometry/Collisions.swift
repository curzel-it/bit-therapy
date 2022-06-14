//
// Pet Therapy.
//

import Squanch
import SwiftUI

public enum Side: String {
    case top
    case bottom
    case left
    case right
}

public typealias Collisions = [Collision]

public struct Collision: Equatable {

    public let bodyId: String
    public let isEphemeral: Bool
    public let mySide: Side
    public let intersection: CGRect
    
    init(with body: PhysicsEntity, on side: Side, in rect: CGRect) {
        self.bodyId = body.id
        self.isEphemeral = body.isEphemeral
        self.mySide = side
        self.intersection = rect
    }
}

extension PhysicsEntity {
    
    func collisions(with neighbors: [PhysicsEntity]) -> Collisions {
        neighbors
            .compactMap { self.collisions(with: $0) }
            .reduce([], +)
    }
    
    func collisions(with other: PhysicsEntity) -> Collisions {
        guard self != other else { return [] }
        let intersection = frame.intersection(other.frame)
        return [
            collisionOnMyTop(with: other, given: intersection),
            collisionOnMyRight(with: other, given: intersection),
            collisionOnMyBottom(with: other, given: intersection),
            collisionOnMyLeft(with: other, given: intersection)
        ].compactMap { $0 }
    }
    
    private func collisionOnMyTop(with other: PhysicsEntity, given intersection: CGRect) -> Collision? {
        if intersection.containsOrTouches(allOf: frame.topRight, frame.topLeft) {
            return .init(with: other, on: .top, in: intersection)
        }
        if intersection.containsOrTouches(anyOf: other.frame.bottomRight, other.frame.bottomLeft) {
            if !intersection.containsOrTouches(anyOf: other.frame.topRight, other.frame.topLeft) {
                return .init(with: other, on: .top, in: intersection)
            }
        }
        return nil
    }
    
    private func collisionOnMyRight(with other: PhysicsEntity, given intersection: CGRect) -> Collision? {
        if intersection.containsOrTouches(allOf: frame.topRight, frame.bottomRight) {
            return .init(with: other, on: .right, in: intersection)
        }
        if intersection.containsOrTouches(anyOf: other.frame.topLeft, other.frame.bottomLeft) {
            if !intersection.containsOrTouches(anyOf: other.frame.topRight, other.frame.bottomRight) {
                return .init(with: other, on: .right, in: intersection)
            }
        }
        return nil
    }
    
    private func collisionOnMyBottom(with other: PhysicsEntity, given intersection: CGRect) -> Collision? {
        if intersection.containsOrTouches(allOf: frame.bottomRight, frame.bottomLeft) {
            return .init(with: other, on: .bottom, in: intersection)
        }
        if intersection.containsOrTouches(anyOf: other.frame.topRight, other.frame.topLeft) {
            if !intersection.containsOrTouches(anyOf: other.frame.bottomRight, other.frame.bottomLeft) {
                return .init(with: other, on: .bottom, in: intersection)
            }
        }
        return nil
    }
    
    private func collisionOnMyLeft(with other: PhysicsEntity, given intersection: CGRect) -> Collision? {
        if intersection.containsOrTouches(allOf: frame.topLeft, frame.bottomLeft) {
            return .init(with: other, on: .left, in: intersection)
        }
        if intersection.containsOrTouches(anyOf: other.frame.topRight, other.frame.bottomRight) {
            if !intersection.containsOrTouches(anyOf: other.frame.topLeft, other.frame.bottomLeft) {
                return .init(with: other, on: .left, in: intersection)
            }
        }
        return nil
    }
}

private extension CGRect {
    
    func containsOrTouches(allOf points: CGPoint...) -> Bool {
        for point in points {
            if !contains(point) && !touches(point) { return false }
        }
        return true
    }
    
    func containsOrTouches(anyOf points: CGPoint...) -> Bool {
        for point in points {
            if contains(point) || touches(point) { return true }
        }
        return false
    }
    
    func touches(_ point: CGPoint) -> Bool {
        if point.x == minX || point.x == maxX {
            return point.y >= minY && point.y <= maxY
        }
        if point.y == minY || point.y == maxY {
            return point.x >= minX && point.x <= maxX
        }
        return false
    }
}
