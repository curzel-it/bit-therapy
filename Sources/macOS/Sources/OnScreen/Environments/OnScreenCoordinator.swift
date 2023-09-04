import SwiftUI
import Yage

protocol OnScreenCoordinator {
    var worlds: [ScreenEnvironment] { get }
    
    func animate(petId: String, actionId: String, position: CGPoint?)
    func hide()
    func remove(species: Species)
    func show()
}
