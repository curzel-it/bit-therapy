import AppKit
import Combine
import Pets
import Schwifty
import Yage

class DesktopEnvironment {
    private var desktopSettings: DesktopSettings
    private var desktopObstacles: DesktopObstaclesService!

    var worlds: [ScreenEnvironment]!
    
    init(settings: DesktopSettings) {
        desktopSettings = settings
        loadWorlds()
        observeWindowsIfNeeded()
    }
    
    private func loadWorlds() {
        worlds = NSScreen.screens
            .filter { desktopSettings.isEnabled(screen: $0) }
            .map {
                ScreenEnvironment(
                    name: $0.localizedName,
                    with: desktopSettings,
                    bounds: $0.frame,
                    entityBuilder: buildEntity
                )
            }
    }
    
    private func observeWindowsIfNeeded() {
        guard desktopSettings.desktopInteractions else { return }
        if let world = worlds.first {
            desktopObstacles = DesktopObstaclesService(world: world)
            desktopObstacles.start()
        }
        installJumpers()
    }
    
    private func installJumpers() {
        worlds
            .flatMap { $0.children }
            .compactMap { $0 as? PetEntity }
            .forEach { $0.setupJumperIfPossible(with: desktopObstacles) }
    }
    
    func startUfoAbductionOfRandomVictim() {
        worlds
            .filter { $0.hasAnyPets }
            .first?
            .startUfoAbductionOfRandomVictim()
    }
    
    func remove(species: Species) {
        worlds.forEach { $0.remove(species: species) }
    }
    
    func buildEntity(species: Species, in bounds: CGRect) -> PetEntity {
        let entity = PetEntity(of: species, in: bounds, settings: desktopSettings)
        ShowsMenuOnRightClick.install(on: entity)
        MouseDraggable.install(on: entity)
        return entity
    }
    
    func kill() {
        desktopObstacles?.stop()
        worlds.forEach { $0.kill() }
    }
}

// MARK: - Screen Environment

class ScreenEnvironment: PetsEnvironment {
    typealias EntityBuilder = (Species, CGRect) -> PetEntity
    
    private var entityBuilder: EntityBuilder
    
    var hasAnyPets: Bool {
        children.contains { $0 is PetEntity }
    }
    
    init(name: String, with settings: PetsSettings, bounds: CGRect, entityBuilder: @escaping EntityBuilder) {
        self.entityBuilder = entityBuilder
        super.init(name: name, with: settings, bounds: bounds)
    }
    
    override func buildEntity(species: Species) -> PetEntity {
        entityBuilder(species, state.bounds)
    }
}

// MARK: - Settings

public protocol DesktopSettings: PetsSettings {
    var desktopInteractions: Bool { get }
    
    func isEnabled(screen: NSScreen) -> Bool
}
