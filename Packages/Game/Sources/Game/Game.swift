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
            WorldView(with: settings, size: $worldSize)
                .measureAvailableSize { worldSize = $0 }
        }
    }
}

private struct WorldView: View {
    @Binding var worldSize: CGSize
    @StateObject var world: GameEnvironment
    @State var entities: [String] = []
        
    init(with settings: PetsSettings, size: Binding<CGSize>) {
        self._worldSize = size
        let env = GameEnvironment(with: settings, bounds: .zero)
        self._world = StateObject(wrappedValue: env)
    }
    
    var body: some View {
        ZStack {
            ForEach(entities, id: \.self) {
                PetView(entityId: $0)
            }
        }
        .offset(x: -worldSize.width/2)
        .offset(y: -worldSize.height/2)
        .environmentObject(world as PetsEnvironment)
        .environmentObject(world as LiveWorld)
        .onReceive(world.state.$children) { newChildren in
            let newIds = newChildren.compactMap { $0 as? PetEntity }.map { $0.id }
            guard entities != newIds else { return }
            entities = newIds
        }
        .onReceive(Just(worldSize)) { newSize in
            world.set(bounds: CGRect(size: newSize))
            world.state.children
                .compactMap { $0.capability(for: AutoRespawn.self) }
                .forEach { $0.teleport() }
        }
    }
}

private struct PetView: View {
    @EnvironmentObject var world: PetsEnvironment
    
    let entityId: String
    
    var body: some View {
        let entity = world.state.children.first { $0.id == entityId }
        if let pet = entity as? PetEntity {
            BaseEntityView(representing: pet, applyOffset: true)
                .draggable(pet)
        }
    }
}

class GameEnvironment: PetsEnvironment {
    override func set(bounds: CGRect) {
        if let ground = ground() {
            ground.kill()
            state.children.remove(ground)
        }
        super.set(bounds: bounds)
        state.children.append(buildGround())
    }
    
    func ground() -> Entity? {
        state.children.first { $0.id == kGround }
    }
    
    func buildGround() -> Entity {
        let entity = Entity(
            id: kGround,
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

private let kGround = "ground"
