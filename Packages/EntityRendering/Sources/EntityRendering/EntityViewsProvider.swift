import AppKit
import Foundation

public class EntityViewsProvider {
    private let assetsProvider: AssetsProvider
    
    public init(assetsProvider: AssetsProvider) {
        self.assetsProvider = assetsProvider
    }
    
    public func view(representing entity: RenderableEntity) -> EntityView {
        PixelArtEntityView(representing: entity, with: assetsProvider)
    }
}
