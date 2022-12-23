import Pets
import Schwifty
import Yage

public struct OnScreen {
    private static var environment: DesktopEnvironment?
    private static var windows: OnScreenWindows?

    public static func show(with settings: DesktopSettings) {
        hide()
        Logger.log("OnScreen", "Starting...")
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
