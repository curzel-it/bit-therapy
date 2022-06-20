//
// Pet Therapy.
//

import AppState
import Biosphere
import DesignSystem
import Pets
import Schwifty
import Squanch
import SwiftUI

class PetSelectionViewModel: HabitatViewModel {
    
    @Published var selectedPet: SelectablePet?
            
    lazy var showingDetails: Binding<Bool> = {
        Binding {
            self.selectedPet != nil
        } set: { isShown in
            guard !isShown else { return }
            self.selectedPet = nil
        }
    }()
    
    let petSize: CGFloat = 90
    
    override init() {
        super.init()
        let pets = Pet.availableSpecies.map {
            SelectablePet($0, size: petSize, in: state.bounds)
        }
        state.children.append(contentsOf: pets)
    }
    
    func showDetails(of pet: SelectablePet?) {
        selectedPet = pet
    }
    
    func closeDetails() {
        selectedPet = nil
    }
}

class SelectablePet: PetEntity {
        
    init(_ pet: Pet, size: CGFloat, in habitatBounds: CGRect) {
        super.init(pet, size: CGSize(square: size), in: habitatBounds)
        set(direction: .zero)
        set(state: .animation(animation: .idleFront))
    }
}
