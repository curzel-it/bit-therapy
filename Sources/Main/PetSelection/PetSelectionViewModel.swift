//
// Pet Therapy.
//

import DesignSystem
import Pets
import Physics
import Squanch
import SwiftUI
import Schwifty

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
        let pets = Pet.species.map {
            SelectablePet($0, size: petSize, bounds: state.bounds)            
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
        
    init(_ pet: Pet, size: CGFloat, bounds: CGRect) {
        super.init(pet, size: CGSize(square: size), in: bounds)
        uninstallAllBehaviors()
        set(direction: .zero)
        set(state: .action(action: .idleFront))
    }
}
