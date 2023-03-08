import Schwifty
import Yage

class OnScreenCoordinatorImpl: OnScreenCoordinator {    
    var worlds: [ScreenEnvironment] = []
    
    func show() {
        hide()
        Logger.log("OnScreen", "Starting...")
        loadWorlds()
    }
    
    private func loadWorlds() {
        worlds = Screen.screens.map { ScreenEnvironment(for: $0) }
    }

    func hide() {
        Logger.log("OnScreen", "Hiding everything...")
        worlds.forEach { $0.kill() }
        worlds.removeAll()
    }

    func remove(species: Species) {
        worlds.forEach { $0.remove(species: species) }
    }
}
