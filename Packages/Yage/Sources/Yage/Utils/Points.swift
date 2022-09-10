import SwiftUI

// MARK: - Angles

extension CGPoint {
    func angle(to other: CGPoint) -> CGFloat {
        let rad = atan2(other.y - y, other.x - x)
        if rad >= 0 { return rad }
        return rad + 2 * .pi
    }
}

// MARK: - Offset

extension CGPoint {
    func offset(by delta: CGPoint) -> CGPoint {
        offset(x: delta.x, y: delta.y)
    }
    
    func offset(by delta: CGSize) -> CGPoint {
        offset(x: delta.width, y: delta.height)
    }
    
    func offset(x: CGFloat=0, y: CGFloat=0) -> CGPoint {
        CGPoint(x: self.x + x, y: self.y + y)
    }
}

// MARK: - Points on Rect

extension CGPoint {
    func isOnEdge(of rect: CGRect) -> Bool {
        if x == rect.minX || x == rect.maxX {
            return rect.minY <= y && y <= rect.maxY
        }
        if y == rect.minY || y == rect.maxY {
            return rect.minX <= x && x <= rect.maxX
        }
        return false
    }
}

// MARK: - Init from Vector

extension CGPoint {
    init(vector: CGVector, radius: CGFloat = 1, offset: CGPoint = .zero) {
        self.init(
            x: radius * vector.dx + offset.x,
            y: radius * vector.dy + offset.y
        )
    }
}
