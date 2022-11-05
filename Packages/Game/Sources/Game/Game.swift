import Combine
import DesignSystem
import Pets
import Schwifty
import SwiftUI
import Yage

public struct GameView: View {
    let settings: PetsSettings
    @State var worldSize: CGSize
    
    public init(with settings: PetsSettings, initialSize: CGSize) {
        self.settings = settings
        self._worldSize = State(wrappedValue: initialSize)
    }
    
    public var body: some View {
        ZStack {
            Background()
                .frame(size: worldSize)
            
            if DeviceRequirement.iOS.isSatisfied {
                WorldView(with: settings, size: $worldSize)
                    .measureScreenSize(to: $worldSize)
            } else {
                WorldView(with: settings, size: $worldSize)
            }
        }
    }
}

private struct WorldView: View {
    @Binding var worldSize: CGSize
    @StateObject var world: GameEnvironment
    
    init(with settings: PetsSettings, size: Binding<CGSize>) {
        self._worldSize = size
        let env = GameEnvironment(with: settings, bounds: .zero)
        self._world = StateObject(wrappedValue: env)
    }
    
    var body: some View {
        ZStack {
            ForEach(world.state.children) { entity in
                if let pet = entity as? PetEntity {
                    BaseEntityView(representing: pet, applyOffset: true)
                }
            }
        }
        .offset(x: -worldSize.width/2)
        .offset(y: -worldSize.height/2)
        .environmentObject(world as PetsEnvironment)
        .environmentObject(world as LiveWorld)
        .onReceive(Just(worldSize)) { newSize in
            printDebug("WorldView", "Got new size", newSize.description)
            world.set(bounds: CGRect(size: newSize))
            world.state.children
                .compactMap { $0.capability(for: AutoRespawn.self) }
                .forEach { $0.teleport() }
        }
    }
}

class GameEnvironment: PetsEnvironment {
    override func set(bounds: CGRect) {
        super.set(bounds: bounds)
        state.children.append(bottomBound())
    }
    
    func bottomBound() -> Entity {
        let entity = Entity(
            id: "ground",
            frame: CGRect(
                x: -1000,
                y: state.bounds.maxY - 100,
                width: state.bounds.width + 2000,
                height: 1000
            ),
            in: state.bounds
        )
        entity.isStatic = true
        return entity
    }
}
