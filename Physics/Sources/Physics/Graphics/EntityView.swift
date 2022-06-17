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
            .lookingTowardsDirection(of: child)
        }
    }
}

private extension View {
    
    func lookingTowardsDirection(of entity: PhysicsEntity) -> some View {
        let direction = entity.facingDirection()
        let xAngle = xAngle(for: direction, isUpsideDown: entity.isUpsideDown)
        let yAngle = yAngle(for: direction, isUpsideDown: entity.isUpsideDown)
        let zAngle = zAngle(for: direction, isUpsideDown: entity.isUpsideDown)
        
        return self
            .rotation3DEffect(xAngle, axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(yAngle, axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(zAngle, axis: (x: 0, y: 0, z: 1))
    }
    
    func xAngle(for direction: CGVector, isUpsideDown: Bool) -> Angle {
        .radians(isUpsideDown ? .pi : .zero)
    }
    
    func yAngle(for direction: CGVector, isUpsideDown: Bool) -> Angle {
        .radians(direction.dx < 0 ? .pi : .zero)
    }
    
    func zAngle(for direction: CGVector, isUpsideDown: Bool) -> Angle {
        if direction.dy < -0.0001 { return .radians(.pi * 1.5) }
        if direction.dy > 0.0001 { return .radians(.pi * 0.5) }
        return .radians(.zero)
    }
}
