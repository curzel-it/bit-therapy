import Combine
import DesignSystem
import Pets
import Schwifty
import SwiftUI
import Yage

class PetsSelectionViewModel: ObservableObject {
    @Published var selectedSpecies: Species?
    @Published var speciesOnStage: [Species] = []
    @Published var unselectedSpecies: [Species] = []
    @Published var canShowDiscordBanner: Bool = true

    lazy var showingDetails: Binding<Bool> = Binding {
        self.selectedSpecies != nil
    } set: { isShown in
        guard !isShown else { return }
        Task { @MainActor in
            self.selectedSpecies = nil
        }
    }

    var gridColums: [GridItem] {
        [.init(.adaptive(minimum: 100, maximum: 140), spacing: Spacing.lg.rawValue)]
    }

    private var stateCanc: AnyCancellable!

    init() {
        loadPets(selectedSpecies: AppState.global.speciesOnStage.value)
        stateCanc = AppState.global.speciesOnStage.sink { self.loadPets(selectedSpecies: $0) }
    }

    private func loadPets(selectedSpecies species: [Species]) {
        speciesOnStage = Species.all.filter { species.contains($0) }
        unselectedSpecies = Species.all.filter { !species.contains($0) }
    }

    func showDetails(of species: Species?) {
        selectedSpecies = species
    }

    func closeDetails() {
        selectedSpecies = nil
    }

    func isSelected(_ species: Species) -> Bool {
        AppState.global.speciesOnStage.value.contains(species)
    }
    
    func image(for species: Species) -> NSImage? {
        let path = PetsAssetsProvider.shared
            .frames(for: species.id, animation: "front")
            .first
        return PetsAssetsProvider.shared.image(sprite: path)
    }
}
