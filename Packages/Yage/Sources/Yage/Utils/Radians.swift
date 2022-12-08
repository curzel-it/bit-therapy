import SwiftUI

// MARK: - Conversion

func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
    guard degrees != 0 else { return 0 }
    guard degrees < 360 else { return degreesToRadians(degrees - 360) }
    guard degrees > 0 else { return degreesToRadians(degrees + 360) }
    return degrees * CGFloat.pi / 180
}

// MARK: - Points

extension CGPoint {
    init(radians: CGFloat, radius: CGFloat = 1, offset: CGPoint = .zero) {
        self.init(
            vector: CGVector(radians: radians),
            radius: radius,
            offset: offset
        )
    }
}

// MARK: - Vectors

extension CGVector {
    var radians: CGFloat {
        let rad = atan2(dy, dx)
        if rad >= 0 { return rad }
        return rad + 2 * .pi
    }

    init(radians: CGFloat) {
        let rad = radians > CGFloat.pi ? CGFloat.pi - radians : radians
        self.init(dx: cos(rad), dy: sin(rad))
    }

    init(degrees: CGFloat) {
        self.init(radians: degreesToRadians(degrees))
    }
}
