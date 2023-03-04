import Foundation
import Schwifty

class CoordinateSystemImpl: CoordinateSystem {
    func frame(of entity: RenderableEntity) -> CGRect {
        let size = max(entity.frame.size, .oneByOne) ?? entity.frame.size
        return CGRect(origin: entity.frame.origin, size: size)
    }
}
