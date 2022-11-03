import Combine
import Pets
import Schwifty
import SwiftUI
import Yage

class DesktopPet: PetEntity {
    override init(of species: Pet, in bounds: CGRect, settings: PetsSettings) {
        super.init(of: species, in: bounds, settings: settings)
        setupMenu()
    }
    
    private func setupMenu() {
        install(ShowsMenuOnRightClick())
    }
}
