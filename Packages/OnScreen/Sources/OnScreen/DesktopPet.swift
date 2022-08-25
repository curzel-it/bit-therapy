// 
// Pet Therapy.
// 

import AppState
import Biosphere
import Combine
import Pets
import Schwifty
import SwiftUI

class DesktopPet: PetEntity {
    
    private var sizeCanc: AnyCancellable!
    
    init(of species: Pet, in habitatBounds: CGRect) {
        super.init(of: species, size: AppState.global.petSize, in: habitatBounds)
        setupPacmanEffect()
        setupMenu()
        setInitialDirection()
        bindSizeToSettings()
    }
    
    private func setupPacmanEffect() {
        guard PacmanEffect.isCompatible(with: self) else { return }
        install(PacmanEffect.self)
    }
    
    private func setupMenu() {
        install(ShowsMenuOnRightClick.self)
    }
    
    private func setInitialDirection() {
        set(direction: .init(dx: 1, dy: 0))
    }
    
    private func bindSizeToSettings() {
        sizeCanc = AppState.global.$petSize.sink { [weak self] size in
            self?.set(size: CGSize(square: size))
        }
    }
    
    override func kill(animated: Bool, onCompletion: @escaping () -> Void = {}) {
        sizeCanc?.cancel()
        super.kill(animated: animated, onCompletion: onCompletion)
    }
}
