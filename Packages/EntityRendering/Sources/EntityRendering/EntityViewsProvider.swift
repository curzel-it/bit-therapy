import AppKit
import Foundation

public class EntityViewsProvider {
    public init() {}
    
    public func view(representing entity: RenderableEntity) -> EntityView {
        PixelArtEntityView(representing: entity)
    }
}
