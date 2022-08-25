//
// Pet Therapy.
//

import Biosphere
import Schwifty
import SwiftUI

struct EntityView: View {
    
    @EnvironmentObject var viewModel: LiveEnvironment
    
    @StateObject var child: Entity
    
    var body: some View {
        ZStack {
            if let sprite = child.sprite {
                Image(nsImage: sprite).pixelArt()
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
