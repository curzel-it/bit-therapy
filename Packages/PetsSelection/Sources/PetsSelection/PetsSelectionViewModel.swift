import Combine
import DesignSystem
import PetDetails
import Pets
import Schwifty
import SwiftUI

class PetsSelectionViewModel: ObservableObject {
    @Published var selectedPet: Pet?
    @Published var selectedPets: [Pet] = []
    @Published var unselectedPets: [Pet] = []
    @Published var canShowDiscordBanner: Bool = true
    
    let localizedContent: LocalizedContentProvider
    let pets: PetsProvider
    
    lazy var showingDetails: Binding<Bool> = {
        Binding {
            self.selectedPet != nil
        } set: { isShown in
            guard !isShown else { return }
            Task { @MainActor in
                self.selectedPet = nil
            }
        }
    }()
    
    var gridColums: [GridItem] {
        let item = GridItem(
            .adaptive(minimum: 100, maximum: 200),
            spacing: Spacing.lg.rawValue
        )
        let numberOfColumns = Screen.main.bounds.width < 500 ? 3 : 5
        return [GridItem](repeating: item, count: numberOfColumns)
    }
    
    private var stateCanc: AnyCancellable!
    
    init(localizedContent: LocalizedContentProvider, pets: PetsProvider) {
        self.localizedContent = localizedContent
        self.pets = pets
        loadPets(selectedPets: pets.petsOnStage.value)
        stateCanc = pets.petsOnStage.sink { self.loadPets(selectedPets: $0) }
    }
    
    private func loadPets(selectedPets species: [Pet]) {
        selectedPets = Pet.availableSpecies.filter { species.contains($0) }
        unselectedPets = Pet.availableSpecies.filter { !species.contains($0) }
    }
    
    func showDetails(of pet: Pet?) {
        selectedPet = pet
    }
    
    func closeDetails() {
        selectedPet = nil
    }
    
    func isSelected(_ pet: Pet) -> Bool {
        pets.petsOnStage.value.contains(pet)
    }
    
    func petDetailsView() -> some View {
        guard let pet = selectedPet else {
            return AnyView(EmptyView())
        }
        return AnyView(
            PetDetailsCoordinator.view(
                isShown: showingDetails,
                localizedContent: localizedContent,
                pet: pet,
                pets: pets
            )
        )
    }
    
}

extension Pet: Identifiable {}

