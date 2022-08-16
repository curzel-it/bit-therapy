//
// Pet Therapy.
//

import DesignSystem
import Schwifty
import SwiftUI

public struct EntityView: View {
    
    @EnvironmentObject var viewModel: LiveEnvironment
    
    @ObservedObject var child: Entity
    
    public init(child: Entity) {
        self.child = child
    }
    
    public var body: some View {
        ZStack {
            if let sprite = child.sprite {
                Image(sprite, scale: 1, label: Text(""))
                    .pixelArt()
            }
            if viewModel.debug {
                Text(child.id)
            }
        }
        .frame(sizeOf: child.frame)
        .rotation3DEffect(.radians(child.xAngle), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.radians(child.yAngle), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.radians(child.zAngle), axis: (x: 0, y: 0, z: 1))
        .background(child.backgroundColor)
    }
}

