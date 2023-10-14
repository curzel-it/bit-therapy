import SwiftUI

public struct Collision: Equatable {
    public weak private(set) var other: Entity?
    public let otherId: String
    public let isEphemeral: Bool
    public let intersection: CGRect
    public let isOverlapping: Bool

    let sourceBody: CGRect
    let otherBody: CGRect

    init(of source: Entity, with other: Entity, on intersection: CGRect) {
        otherId = other.id
        isEphemeral = other.isEphemeral
        self.other = other
        self.intersection = intersection
        sourceBody = source.frame
        otherBody = other.frame
        isOverlapping = intersection.width >= 1 && intersection.height >= 1
    }
}

public extension Collision {
    enum Side {
        case top, right, bottom, left
    }

    func sides() -> [Side] {
        var sides: [Side] = []
        let bodyCenter = sourceBody.center
        let angle = bodyCenter.angle(to: intersection.center)

        func inBetween(_ angle: CGFloat, _ pi1: CGFloat, _ pi2: CGFloat) -> Bool {
            if pi1 == 2 || pi2 == 2 || pi1 == 0 || pi2 == 0 {
                if angle == 0 || abs(angle - 2 * .pi) < 0.0001 {
                    return true
                }
            }
            return angle >= pi1 * .pi && pi2 <= pi2 * .pi
        }

        let intersectionEdges = intersection.corners.filter { $0.isOnEdge(of: sourceBody) }
        let touchesTop = intersectionEdges.contains { bodyCenter.y < $0.y && $0.y <= sourceBody.maxY }
        let touchesRight = intersectionEdges.contains { bodyCenter.x < $0.x && $0.x <= sourceBody.maxX }
        let touchesBottom = intersectionEdges.contains { bodyCenter.y > $0.y && $0.y >= sourceBody.minY }
        let touchesLeft = intersectionEdges.contains { bodyCenter.x > $0.x && $0.x >= sourceBody.minX }

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

// MARK: - Collisions

public typealias Collisions = [Collision]

extension Entity {
    func collisions(with neighbors: [Entity]) -> Collisions {
        neighbors
            .filter { $0 != self }
            .compactMap { collision(with: $0) }
    }

    func collision(with other: Entity) -> Collision? {
        let intersection = frame.intersection(other.frame)
        guard !intersection.isNull, !intersection.isInfinite else { return nil }
        return Collision(of: self, with: other, on: intersection)
    }
}
