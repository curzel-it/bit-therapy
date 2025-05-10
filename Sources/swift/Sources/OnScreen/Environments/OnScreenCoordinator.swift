import SwiftUI

protocol OnScreenCoordinator {
    var worlds: [ScreenEnvironment] { get }

    func animate(petId: String, actionId: String, position: CGPoint?)
    func togglePetsVisibility()
    func hide()
    func show()
    func remove(species: Species)
}
