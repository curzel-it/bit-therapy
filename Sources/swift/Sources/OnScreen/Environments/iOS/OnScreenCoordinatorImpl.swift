import Schwifty
import SwiftUI

class OnScreenCoordinatorImpl: OnScreenCoordinator {
    var worlds: [ScreenEnvironment] = []

    private let tag = "OnScreen"

    func togglePetsVisibility() {}
    func show() {}
    func hide() {}

    func remove(species: Species) {}

    func animate(petId: String, actionId: String, position: CGPoint?) {
        worlds.forEach {
            $0.animate(id: petId, action: actionId, position: position)
        }
    }
}
