import AppKit
import Combine
import Pets
import Schwifty
import Yage

class DesktopEnvironment: PetsEnvironment {
    private var onScreenSettings: OnScreenSettings
    private var desktopObstacles: DesktopObstaclesService!

    init(settings: OnScreenSettings) {
        onScreenSettings = settings
        super.init(with: settings, bounds: NSScreen.main?.frame.bounds ?? .zero)
        observeWindowsIfNeeded()
    }

    private func observeWindowsIfNeeded() {
        guard onScreenSettings.desktopInteractions else { return }
        desktopObstacles = DesktopObstaclesService(world: self)
        desktopObstacles.start()
        state.children.forEach {
            guard let pet = $0 as? PetEntity else { return }
            pet.setupJumperIfPossible(with: desktopObstacles)
        }
    }

    override func buildEntity(species: Species) -> PetEntity {
        let entity = PetEntity(of: species, in: state.bounds, settings: onScreenSettings)
        ShowsMenuOnRightClick.install(on: entity)
        entity.setupJumperIfPossible(with: desktopObstacles)
        return entity
    }

    override func kill() {
        desktopObstacles?.stop()
        super.kill()
    }
}

public protocol OnScreenSettings: PetsSettings {
    var desktopInteractions: Bool { get }
}

extension DesktopObstaclesService: JumperPlatformsProvider {
    func platforms() -> [Entity] {
        world.children.filter { $0.isWindowObstacle || $0.isGround }
    }
}

private extension Entity {
    var isGround: Bool {
        id == Hotspot.bottomBound.rawValue
    }
}

private extension PetEntity {
    func setupJumperIfPossible(with platforms: JumperPlatformsProvider?) {
        guard let platforms = platforms else { return }
        guard RandomPlatformJumper.compatible(with: self) else { return }
        let jumper = RandomPlatformJumper.install(on: self)
        jumper.start(with: platforms)
    }
}
