import Combine
import Schwifty
import SwiftUI
import Yage

class ScreensaverViewModel: WorldViewModel, ObservableObject {
    @Inject var config: AppConfig
    @Inject var species: SpeciesProvider
    @Inject var elements: ScreensaverElementsService
    @Published var entities: [EntityViewModel] = []
    
    private var didLoadPets = false
    private let tag = "screensaver"
    
    init() {
        let world = World(name: "screensaver", bounds: .zero)
        super.init(representing: world)
        reloadElements()
        reloadPets()
    }
    
    func updateWorldSize(to size: CGSize) {
        world.set(bounds: CGRect(origin: .zero, size: size))
        world.children
            .compactMap { $0 as? PetEntity }
            .forEach { $0.setInitialPosition() }
    }
    
    override func loop() {
        super.loop()
        updateViews()
        removeOldEntities()
        addNewEntities()
    }
    
    private func reloadElements() {
        let elements = elements.elements(for: world)
        world.children.append(contentsOf: elements)
    }
    
    private func reloadPets() {
        let current = world.children.map { $0.id }
        config.selectedSpecies
            .compactMap { species.by(id: $0) }
            .filter { !current.contains($0.id) }
            .forEach {
                let entity = PetEntity(of: $0, in: world)
                world.children.append(entity)
            }
    }
    
    private func updateViews() {
        entities.forEach { $0.update() }
    }
    
    private func removeOldEntities() {
        let previous = entities.map { $0.entityId }
        let current = world.renderableChildren.map { $0.id }
        let idsToRemove: [String] = previous.reduce(into: []) { result, id in
            if !current.contains(id) {
                result.append(id)
            }
        }
        entities.removeAll { idsToRemove.contains($0.entityId) }
    }
    
    private func addNewEntities() {
        let previousEntitiesIds = entities.map { $0.entityId }
        world.renderableChildren
            .filter { !previousEntitiesIds.contains($0.id) }
            .forEach { add($0) }
    }
    
    private func add(_ entity: RenderableEntity) {
        let vm = EntityViewModel(representing: entity, in: .topDown)
        vm.scaleFactor = Screen.main?.scale ?? 1
        entities.append(vm)
    }
}
