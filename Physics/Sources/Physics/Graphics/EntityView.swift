//
// Pet Therapy.
//

import DesignSystem
import SwiftUI
import Schwifty

public struct EntityView: View {
    
    @EnvironmentObject var viewModel: HabitatViewModel
    
    @ObservedObject var child: PhysicsEntity
    
    public init(child: PhysicsEntity) {
        self.child = child
    }
    
    public var body: some View {
        if child.isDrawable {
            ZStack {
                ForEach(child.sprites) { sprite in
                    if sprite.isDrawable, let image = sprite.currentFrame {
                        Image(nsImage: image)
                            .pixelArt()
                            .frame(sizeOf: child.frame)
                    }
                }
            }
            .frame(sizeOf: child.frame)
            .background(child.backgroundColor)
            .look(towards: child.facingDirection())
            .positionAndRotate(child)
        }
    }
}

private extension View {
    
    func look(towards direction: CGVector) -> some View {
        rotation3DEffect(
            .radians(direction.dx < 0 ? .pi : 0),
            axis: (x: 0, y: 1, z: 0)
        )
    }
    
    func positionAndRotate(_ child: PhysicsEntity) -> some View {
        self
            .offset(x: -child.frame.minX)
            .offset(y: -child.frame.minY)
            .rotationEffect(Angle(radians: -child.angle))
            .offset(x: child.frame.minX)
            .offset(y: child.frame.minY)
    }
}
