import SwiftUI
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
    
    func animate(petId: String, actionId: String, position: CGPoint?) {
        worlds.forEach {
            $0.animate(id: petId, action: actionId, position: position)
        }
    }
}
