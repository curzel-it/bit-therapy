//
// Pet Therapy.
//

import DesignSystem
import SwiftUI
import Schwifty

public struct EntityView: View {
    
    @EnvironmentObject var viewModel: HabitatViewModel
    
    @ObservedObject var child: Entity
    
    public init(child: Entity) {
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
            .rotation3DEffect(.radians(child.xAngle), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.radians(child.yAngle), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.radians(child.zAngle), axis: (x: 0, y: 0, z: 1))
        }
    }
}
