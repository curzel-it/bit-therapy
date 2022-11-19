import AppKit
import Combine
import Pets
import Schwifty
import Yage

public struct OnScreen {
    private static var viewModel: DesktopEnvironment?
    private static var windows: OnScreenWindows?
    
    public static func show(with settings: OnScreenSettings) {
        hide()
        printDebug("OnScreen", "Starting...")
        self.viewModel = DesktopEnvironment(settings: settings)
        self.windows = OnScreenWindows(for: viewModel)
    }
    
    public static func hide() {
        printDebug("OnScreen", "Hiding everything...")
        viewModel?.kill()
        viewModel = nil
        windows?.kill()
        windows = nil
    }
    
    public static func triggerUfoAbduction() {
        printDebug("OnScreen", "Triggering UFO Abduction...")
        viewModel?.startUfoAbductionOfRandomVictim()
    }
    
    public static func remove(pet: Pet) {
        viewModel?.remove(pet: pet)
    }
}

class DesktopEnvironment: PetsEnvironment {
    private var onScreenSettings: OnScreenSettings
    private var desktopObstacles: DesktopObstaclesService!
    
    init(settings: OnScreenSettings) {
        self.onScreenSettings = settings
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
    
    override func buildEntity(pet species: Pet) -> PetEntity {
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
