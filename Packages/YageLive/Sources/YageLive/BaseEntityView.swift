import PetsAssets
import SwiftUI
import Yage

public struct BaseEntityView: View {
    @EnvironmentObject var viewModel: LiveWorld

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
            if viewModel.debug {
                Text("\(entity.id) \(entity.frame.description)")
            }
        }
        .frame(sizeOf: entity.frame)
        .rotation3DEffect(.radians(entity.xAngle), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.radians(entity.yAngle), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.radians(entity.zAngle), axis: (x: 0, y: 0, z: 1))
        .background(entity.backgroundColor)
        .offset(x: applyOffset ? entity.frame.midX : 0)
        .offset(y: applyOffset ? entity.frame.midY : 0)
    }
}
