import AppState
import Combine
import DesignSystem
import Pets
import Schwifty
import Squanch
import SwiftUI

class HomepageViewModel: ObservableObject {
    
    @Published var selectedPet: Pet?
    @Published var selectedPets: [Pet] = []
    @Published var unselectedPets: [Pet] = []
    @Published var canShowDiscordBanner: Bool = true
    
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
    
    private var stateCanc: AnyCancellable!
    
    init() {
        loadPets(selectedPets: AppState.global.selectedPets)
        stateCanc = AppState.global.$selectedPets.sink { self.loadPets(selectedPets: $0) }
    }
    
    private func loadPets(selectedPets ids: [String]) {
        selectedPets = Pet.availableSpecies.filter { ids.contains($0.id) }
        unselectedPets = Pet.availableSpecies.filter { !ids.contains($0.id) }
    }
    
    func showDetails(of pet: Pet?) {
        selectedPet = pet
    }
    
    func closeDetails() {
        selectedPet = nil
    }
    
    func visitDiscord() {
        
    }
}

extension Pet: Identifiable {}

