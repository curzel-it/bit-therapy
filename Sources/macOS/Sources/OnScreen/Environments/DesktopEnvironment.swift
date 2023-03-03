import Combine
import Schwifty
import Yage

class DesktopEnvironment {
    private var settings: AppState { AppState.global }

    var worlds: [ScreenEnvironment]!
    
    init() {
        worlds = Screen.screens
            .filter { settings.isEnabled(screen: $0) }
            .map { ScreenEnvironment(for: $0) }
    }
    
    func remove(species: Species) {
        worlds.forEach { $0.remove(species: species) }
    }
    
    func kill() {
        worlds.forEach { $0.kill() }
    }
}
