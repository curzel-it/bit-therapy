import Schwifty
import Yage

class OnScreenCoordinatorImpl: OnScreenCoordinator {    
    var worlds: [ScreenEnvironment] = []
    
    private let tag = "OnScreen"
    
    func show() {
        Logger.log(tag, "Not supported on mobile.")
    }
    
    private func loadWorlds() {}

    func hide() {}

    func remove(species: Species) {}
}
