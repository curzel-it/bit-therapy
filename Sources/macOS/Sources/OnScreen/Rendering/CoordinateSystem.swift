import Foundation

protocol CoordinateSystem {
    func frame(of entity: RenderableEntity) -> CGRect
}
