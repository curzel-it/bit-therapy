import AppState
import DesignSystem
import Pets
import Schwifty
import Squanch
import SwiftUI

class HomepageViewModel: ObservableObject {
    
    @Published var selectedPet: Pet?
    
    let pets: [Pet]
    
    var selectedPets: [Pet] {
        let selectedIds = AppState.global.selectedPets
        return pets.filter { selectedIds.contains($0.id) }
    }
    
    var unselectedPets: [Pet] {
        let selectedIds = AppState.global.selectedPets
        return pets.filter { !selectedIds.contains($0.id) }
    }
            
    lazy var showingDetails: Binding<Bool> = {
        Binding {
            self.selectedPet != nil
        } set: { isShown in
            guard !isShown else { return }
            self.selectedPet = nil
        }
    }()
    
    var gridColums: [GridItem] {
        let item = GridItem(
            .adaptive(minimum: 100, maximum: 200),
            spacing: Spacing.lg.rawValue
        )
        return [GridItem](repeating: item, count: 5)
    }
    
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

