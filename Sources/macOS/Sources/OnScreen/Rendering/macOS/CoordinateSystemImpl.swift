import Foundation
import Schwifty

class CoordinateSystemImpl: CoordinateSystem {
    func frame(of entity: RenderableEntity) -> CGRect {
        let size = max(entity.frame.size, .oneByOne) ?? entity.frame.size
        return CGRect(
            origin: .zero
                .offset(x: entity.frame.minX)
                .offset(y: entity.windowSize.height)
                .offset(y: -entity.frame.maxY),
            size: size
        )
    }
}
