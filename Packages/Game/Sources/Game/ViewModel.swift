import Combine
import Pets
import SwiftUI
import Yage

class ViewModel: ObservableObject {
    @Published var gotUsername = false
    @Published var username: String = ""
    @Published var worldSize: CGSize {
        didSet {
            world.set(bounds: CGRect(size: worldSize))
            world.state.children
                .compactMap { $0.capability(for: AutoRespawn.self) }
                .forEach { $0.teleport() }
        }
    }
    @Published var world: GameEnvironment
    @Published var entities: [String] = []
    @Published var fruitIndex: Int = -1
    
    let settings: PetsSettings
    let lang: LocalizedContentProvider
    
    private var childrenCanc: AnyCancellable!
    
    init(
        with settings: PetsSettings,
        initialSize size: CGSize,
        localizedContent: LocalizedContentProvider
    ) {
        self.worldSize = size
        self.settings = settings
        self.lang = localizedContent
        self.world = GameEnvironment(
            with: settings,
            bounds: CGRect(size: size)
        )
        childrenCanc = world.state.$children.sink { newChildren in
            self.entities = newChildren.map { $0.id }
        }
    }
}
