import Yage

protocol OnScreenCoordinator {
    var worlds: [ScreenEnvironment] { get }
    
    func show()
    func hide()
    func remove(species: Species)
}
