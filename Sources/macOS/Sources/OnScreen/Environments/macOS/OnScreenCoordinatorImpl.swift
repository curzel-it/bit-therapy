import AppKit
import Schwifty
import Yage

class OnScreenCoordinatorImpl: OnScreenCoordinator {
    private var environment: DesktopEnvironment?
    private var windows: [NSWindow] = []
    private let windowsProvider = WorldWindowsProvider()

    func show() {
        hide()
        Logger.log("OnScreen", "Starting...")
        environment = DesktopEnvironment()
        spawnWindows()
    }

    func hide() {
        Logger.log("OnScreen", "Hiding everything...")
        environment?.kill()
        environment = nil
        windows.forEach { $0.close() }
        windows.removeAll()
    }

    func remove(species: Species) {
        environment?.remove(species: species)
    }
    
    private func spawnWindows() {
        let worlds = environment?.worlds ?? []
        windows = worlds.map { windowsProvider.window(representing: $0) }
        windows.forEach { $0.show() }
    }
}

class WorldWindowsProvider {
    func window(representing world: RenderableWorld) -> NSWindow {
        WorldWindow(representing: world)
    }
}
