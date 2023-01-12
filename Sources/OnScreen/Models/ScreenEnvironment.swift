import AppKit
import Combine
import Schwifty
import Yage

class DesktopEnvironment {
    private var settings: AppState { AppState.global }
    private var desktopObstacles: DesktopObstaclesService!

    var worlds: [ScreenEnvironment]!
    
    init() {
        loadWorlds()
        observeWindowsIfNeeded()
    }
    
    private func loadWorlds() {
        worlds = NSScreen.screens
            .filter { settings.isEnabled(screen: $0) }
            .map { ScreenEnvironment(for: $0) }
    }
    
    private func observeWindowsIfNeeded() {
        guard settings.desktopInteractions else { return }
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
    
    func kill() {
        desktopObstacles?.stop()
        worlds.forEach { $0.kill() }
    }
}
