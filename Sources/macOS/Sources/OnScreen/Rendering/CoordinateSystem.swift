import Schwifty
import SwiftUI

class CoordinateSystem {
    static let bottomUp = CoordinateSystem { entity in
        let size = max(entity.frame.size, .oneByOne) ?? entity.frame.size
        return CGRect(
            origin: .zero
                .offset(x: entity.frame.minX)
                .offset(y: entity.windowSize.height)
                .offset(y: -entity.frame.maxY),
            size: size
        )
    }
    
    static let topDown = CoordinateSystem { entity in
        let size = max(entity.frame.size, .oneByOne) ?? entity.frame.size
        return CGRect(origin: entity.frame.origin, size: size)
    }
    
    private let frameBuilder: (RenderableEntity) -> CGRect
    
    private init(frameBuilder: @escaping (RenderableEntity) -> CGRect) {
        self.frameBuilder = frameBuilder
    }
    
    func frame(of entity: RenderableEntity) -> CGRect {
        frameBuilder(entity)
    }
}

private extension CGSize {
    var center: CGPoint {
        CGRect(size: self).center
    }
}
