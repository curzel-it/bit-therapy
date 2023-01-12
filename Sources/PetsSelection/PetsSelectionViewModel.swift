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
    @Published private var selectedTags = Set<String>()

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

    private var disposables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest3(
            Species.all,
            AppState.global.speciesOnStage,
            $selectedTags
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] all, selected, tags in
            self?.loadPets(all: all, selected: selected, tags: tags)
        }
        .store(in: &disposables)
    }
    
    func filtersChanged(to tags: Set<String>) {
        selectedTags = tags
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

    private func loadPets(all: [Species], selected: [Species], tags: Set<String>) {
        speciesOnStage = all.filter { selected.contains($0) }
        unselectedSpecies = all
            .filter { tags.isEmpty || $0.tags.contains(anyOf: tags) }
            .filter { !selected.contains($0) }
    }
}
