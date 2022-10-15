import Pets
import SwiftUI
import Yage

struct HomeView: View {
    @StateObject var world: LiveWorld
    
    init() {
        let world = LiveWorld(id: "ios", bounds: UIScreen.main.bounds)
        world.debug = true
        let pet = PetEntity(of: .sloth, size: 70, in: world.state.bounds)
        pet.set(direction: CGVector(dx: 1, dy: 0))
        world.state.children.append(pet)
        self._world = StateObject(wrappedValue: world)
    }
    
    var body: some View {
        ZStack {
            ForEach(world.state.children) { child in
                EntityView(entity: child)
            }
        }
        .environmentObject(world)
    }
}

private struct EntityView: View {
    @EnvironmentObject var viewModel: LiveWorld
    @StateObject var entity: Entity
    
    var body: some View {
        ZStack {
            if let sprite = entity.sprite {
                Image(frame: sprite).pixelArt()
            }
            if viewModel.debug {
                Text(entity.id)
            }
        }
        .frame(sizeOf: entity.frame)
        .rotation3DEffect(.radians(entity.xAngle), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.radians(entity.yAngle), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.radians(entity.zAngle), axis: (x: 0, y: 0, z: 1))
        .background(entity.backgroundColor)
        .offset(x: entity.frame.minX)
        .offset(y: entity.frame.minY)
    }
}
