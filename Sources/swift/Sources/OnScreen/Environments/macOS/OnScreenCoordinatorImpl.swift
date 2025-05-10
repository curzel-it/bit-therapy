import AppKit
import Schwifty

class OnScreenCoordinatorImpl: OnScreenCoordinator {
    @Inject private var appConfig: AppConfig

    var worlds: [ScreenEnvironment] = []
    private var windows: [NSWindow] = []
    private let windowsProvider = WorldWindowsProvider()
    private let tag = "OnScreen"
    
    func togglePetsVisibility() {
        if arePetsVisible() {
            hide()
        } else {
            show()
        }
    }
    
    func show() {
        hide()
        Logger.log(tag, "Starting...")
        loadWorlds()
        spawnWindows()
    }
    
    func hide() {
        Logger.log(tag, "Hiding everything...")
        worlds.forEach { $0.kill() }
        worlds.removeAll()
        windows.forEach { $0.close() }
        windows.removeAll()
    }

    func animate(petId: String, actionId: String, position: CGPoint?) {
        worlds.forEach {
            $0.animate(id: petId, action: actionId, position: position)
        }
    }

    func remove(species: Species) {
        worlds.forEach { $0.remove(species: species) }
    }

    private func spawnWindows() {
        windows = worlds.map { windowsProvider.window(representing: $0) }
        windows.forEach { $0.show() }
    }
    
    private func arePetsVisible() -> Bool {
        !worlds.isEmpty
    }
    
    private func loadWorlds() {
        worlds = Screen.screens
            .filter { appConfig.isEnabled(screen: $0) }
            .map { ScreenEnvironment(for: $0) }
    }
}

class WorldWindowsProvider {
    func window(representing world: World) -> NSWindow {
        WorldWindow(representing: world)
    }
}
