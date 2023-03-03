import Schwifty
import Yage

class OnScreenCoordinatorImpl: OnScreenCoordinator {
    private var environment: DesktopEnvironment?
    
    func show() {
        hide()
        Logger.log("OnScreen", "Starting...")
        environment = DesktopEnvironment()
    }

    func hide() {
        Logger.log("OnScreen", "Hiding everything...")
        environment?.kill()
        environment = nil
    }

    func remove(species: Species) {
        environment?.remove(species: species)
    }
}
