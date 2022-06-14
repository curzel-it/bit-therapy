//
// Pet Therapy.
//

import Combine
import DesignSystem
import Physics
import SwiftUI

class AppState: ObservableObject {
    
    static var global = AppState()
    
    @Published var selectedPage: AppPage = .home
    
    @Published var selectedPet: Pet? {
        didSet {
            guard let id = selectedPet?.id else { return }
            petId = id
        }
    }
    
    @Published var petSize: CGFloat = PetSize.defaultSize {
        didSet {
            petSizeValue = petSize
        }
    }
    
    @Published var speedMultiplier: CGFloat = 1 {
        didSet {
            speedMultiplierValue = speedMultiplier
        }
    }
    
    @AppStorage("speedMultiplier") var speedMultiplierValue: Double = 1
    @AppStorage("petSize") var petSizeValue: Double = PetSize.defaultSize
    @AppStorage("gravityEnabled") var gravityEnabled = false
    @AppStorage("showInMenuBar") var statusBarIconEnabled = true
    @AppStorage("petId") var petId: String = Pet.sloth.id
    @AppStorage("trackingEnabled") var trackingEnabled = false
        
    private init() {
        if let pet = Pet.species.first(where: { $0.id == petId }) {
            selectedPet = pet
        }
        petSize = petSizeValue
        speedMultiplier = speedMultiplierValue
    }
}

enum AppPage: String, CaseIterable {
    case home
    case settings
    case about
}
