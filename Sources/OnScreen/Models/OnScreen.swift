import AppKit
import Schwifty
import Yage

public struct OnScreenCoordinator {
    private static var environment: DesktopEnvironment?
    private static var windows: [NSWindow] = []

    public static func show() {
        hide()
        Logger.log("OnScreen", "Starting...")
        environment = DesktopEnvironment()
        spawnWindows()
    }
    
    private static func spawnWindows() {
        let worlds = environment?.worlds ?? []
        windows = worlds.map { PetsWindow(representing: $0) }
        windows.forEach { $0.show() }
    }

    public static func hide() {
        Logger.log("OnScreen", "Hiding everything...")
        environment?.kill()
        environment = nil
        windows.forEach { $0.close() }
        windows.removeAll()
    }

    public static func triggerUfoAbduction() {
        Logger.log("OnScreen", "Triggering UFO Abduction...")
        environment?.startUfoAbductionOfRandomVictim()
    }

    public static func remove(species: Species) {
        environment?.remove(species: species)
    }
}
