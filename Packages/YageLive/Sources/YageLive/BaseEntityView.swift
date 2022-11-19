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
            if let sprite = entity.sprite {
                Image(frame: sprite).pixelArt()
            }
            ForEach(entity.layers) { layer in
                Image(frame: layer.sprite)
                    .pixelArt()
                    .offset(x: -entity.frame.width/2)
                    .offset(y: -entity.frame.height/2)
                    .frame(sizeOf: layer.frame)
                    .offset(x: layer.frame.midX)
                    .offset(y: layer.frame.midY)
                    .rotation3DEffect(.radians(layer.zAngle), axis: (x: 0, y: 0, z: 1))
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
