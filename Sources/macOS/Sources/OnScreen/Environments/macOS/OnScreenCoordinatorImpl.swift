import AppKit
import Schwifty
import Yage

class OnScreenCoordinatorImpl: OnScreenCoordinator {
    var worlds: [ScreenEnvironment] = []
    private var windows: [NSWindow] = []
    private let windowsProvider = WorldWindowsProvider()

    func show() {
        hide()
        Logger.log("OnScreen", "Starting...")
        loadWorlds()
        spawnWindows()
    }
    
    private func loadWorlds() {
        worlds = Screen.screens
            .filter { AppState.global.isEnabled(screen: $0) }
            .map { ScreenEnvironment(for: $0) }
    }

    func hide() {
        Logger.log("OnScreen", "Hiding everything...")
        worlds.forEach { $0.kill() }
        worlds.removeAll()
        windows.forEach { $0.close() }
        windows.removeAll()
    }

    func remove(species: Species) {
        worlds.forEach { $0.remove(species: species) }
    }
    
    private func spawnWindows() {
        windows = worlds.map { windowsProvider.window(representing: $0) }
        windows.forEach { $0.show() }
    }
}

class WorldWindowsProvider {
    func window(representing world: RenderableWorld) -> NSWindow {
        WorldWindow(representing: world)
    }
}
