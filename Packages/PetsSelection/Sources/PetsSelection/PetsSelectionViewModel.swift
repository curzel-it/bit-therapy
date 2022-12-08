import Combine
import DesignSystem
import PetDetails
import Pets
import Schwifty
import SwiftUI
import Yage

class PetsSelectionViewModel: ObservableObject {
    @Published var selectedSpecies: Species?
    @Published var speciesOnStage: [Species] = []
    @Published var unselectedSpecies: [Species] = []
    @Published var canShowDiscordBanner: Bool = true

    let localizedContent: LocalizedContentProvider
    let speciesProvider: PetsProvider

    lazy var showingDetails: Binding<Bool> = Binding {
        self.selectedSpecies != nil
    } set: { isShown in
        guard !isShown else { return }
        Task { @MainActor in
            self.selectedSpecies = nil
        }
    }

    var gridColums: [GridItem] {
        let item = GridItem(
            .adaptive(minimum: 100, maximum: 200),
            spacing: Spacing.lg.rawValue
        )
        let numberOfColumns = Screen.main.bounds.width < 500 ? 3 : 5
        return [GridItem](repeating: item, count: numberOfColumns)
    }

    private var stateCanc: AnyCancellable!

    init(localizedContent: LocalizedContentProvider, speciesProvider: PetsProvider) {
        self.localizedContent = localizedContent
        self.speciesProvider = speciesProvider
        loadPets(selectedSpecies: speciesProvider.speciesOnStage.value)
        stateCanc = speciesProvider.speciesOnStage.sink { self.loadPets(selectedSpecies: $0) }
    }

    private func loadPets(selectedSpecies species: [Species]) {
        speciesOnStage = Species.availableSpecies.filter { species.contains($0) }
        unselectedSpecies = Species.availableSpecies.filter { !species.contains($0) }
    }

    func showDetails(of species: Species?) {
        selectedSpecies = species
    }

    func closeDetails() {
        selectedSpecies = nil
    }

    func isSelected(_ species: Species) -> Bool {
        speciesProvider.speciesOnStage.value.contains(species)
    }

    func petDetailsView() -> some View {
        guard let species = selectedSpecies else {
            return AnyView(EmptyView())
        }
        return AnyView(
            PetDetailsCoordinator.view(
                isShown: showingDetails,
                localizedContent: localizedContent,
                species: species,
                speciesProvider: speciesProvider
            )
        )
    }
}
