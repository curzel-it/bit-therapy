import AppState
import DesignSystem
import Pets
import Schwifty
import Squanch
import SwiftUI

class PetSelectionViewModel: ObservableObject {
    
    @Published var selectedPet: Pet?
    
    let pets: [Pet]
            
    lazy var showingDetails: Binding<Bool> = {
        Binding {
            self.selectedPet != nil
        } set: { isShown in
            guard !isShown else { return }
            self.selectedPet = nil
        }
    }()
    
    init() {
        pets = Pet.availableSpecies
    }
    
    func showDetails(of pet: Pet?) {
        selectedPet = pet
    }
    
    func closeDetails() {
        selectedPet = nil
    }
}

extension Pet: Identifiable {}
