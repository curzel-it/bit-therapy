import PetsAssets
import SwiftUI
import Yage

public struct BaseEntityView: View {
    let entity: Entity
    let applyOffset: Bool

    public init(representing entity: Entity, applyOffset: Bool = false) {
        self.applyOffset = applyOffset
        self.entity = entity
    }

    public var body: some View {
        ZStack {
            if let image = PetsAssetsProvider.shared.image(sprite: entity.sprite) {
                Image(frame: image).pixelArt()
            }
        }
        .frame(sizeOf: entity.frame)
        // .rotated(with: entity.rotation?.angles)
        .offset(x: applyOffset ? entity.frame.midX : 0)
        .offset(y: applyOffset ? entity.frame.midY : 0)
    }
}
/*
private extension View {
    func rotated(with rotation: Rotation?) -> some View {
        self
            .rotation3DEffect(.radians(rotation?.x ?? 0), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.radians(rotation?.y ?? 0), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.radians(rotation?.z ?? 0), axis: (x: 0, y: 0, z: 1))
    }
}
*/
