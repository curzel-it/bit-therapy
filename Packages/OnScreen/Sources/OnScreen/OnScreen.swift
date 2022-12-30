import AppKit
import Pets
import Schwifty
import Yage

public struct OnScreenCoordinator {
    private static var environment: DesktopEnvironment?
    private static var windows: OnScreenWindows?
    static var assetsProvider: AssetsProvider = NoAssets()

    public static func show(with settings: DesktopSettings, assets: AssetsProvider) {
        hide()
        Logger.log("OnScreen", "Starting...")
        assetsProvider = assets
        environment = DesktopEnvironment(settings: settings)
        windows = OnScreenWindows(for: environment?.worlds ?? [])
    }

    public static func hide() {
        Logger.log("OnScreen", "Hiding everything...")
        environment?.kill()
        environment = nil
        windows?.kill()
        windows = nil
    }

    public static func triggerUfoAbduction() {
        Logger.log("OnScreen", "Triggering UFO Abduction...")
        environment?.startUfoAbductionOfRandomVictim()
    }

    public static func remove(species: Species) {
        environment?.remove(species: species)
    }
}

public protocol AssetsProvider: AnyObject {
    func image(sprite: String?) -> NSImage?
}

private class NoAssets: AssetsProvider {
    func image(sprite: String?) -> NSImage? { nil }
}
