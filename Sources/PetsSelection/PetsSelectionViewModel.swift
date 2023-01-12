import Combine
import DesignSystem
import Schwifty
import SwiftUI
import Yage

class PetsSelectionViewModel: ObservableObject {
    @Published var selectedSpecies: Species?
    @Published var speciesOnStage: [Species] = []
    @Published var unselectedSpecies: [Species] = []
    @Published var canShowDiscordBanner: Bool = true
    @Published private var selectedTag: String?

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
            $selectedTag
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] all, onStage, tag in
            self?.loadPets(all: all, selected: onStage, tag: tag)
        }
        .store(in: &disposables)
    }
    
    func filterChanged(to tag: String?) {
        selectedTag = tag
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

    private func loadPets(all: [Species], selected: [Species], tag: String?) {
        speciesOnStage = all.filter { selected.contains($0) }
        unselectedSpecies = all.filter { tag == nil || $0.tags.contains(tag ?? "") }
    }
}
