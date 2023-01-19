import Combine
import DesignSystem
import Schwifty
import SwiftUI
import Yage

class PetsSelectionViewModel: ObservableObject {
    @Published var openSpecies: Species?
    @Published var selectedSpecies: [Species] = []
    @Published var unselectedSpecies: [Species] = []
    @Published var canShowDiscordBanner: Bool = true
    @Published private var selectedTag: String?

    lazy var showingDetails: Binding<Bool> = Binding {
        self.openSpecies != nil
    } set: { isShown in
        guard !isShown else { return }
        Task { @MainActor in
            self.openSpecies = nil
        }
    }

    var gridColums: [GridItem] {
        [.init(.adaptive(minimum: 100, maximum: 140), spacing: Spacing.lg.rawValue)]
    }

    private var disposables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest3(
            Species.all,
            AppState.global.$selectedSpecies,
            $selectedTag
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] all, selected, tag in
            self?.loadPets(all: all, selected: selected, tag: tag)
        }
        .store(in: &disposables)
    }
    
    func filterChanged(to tag: String?) {
        selectedTag = tag
    }

    func showDetails(of species: Species?) {
        openSpecies = species
    }

    func closeDetails() {
        openSpecies = nil
    }

    func isSelected(_ species: Species) -> Bool {
        AppState.global.selectedSpecies.contains(species)
    }
    
    func image(for species: Species) -> NSImage? {
        let path = PetsAssetsProvider.shared
            .frames(for: species.id, animation: "front")
            .first
        return PetsAssetsProvider.shared.image(sprite: path)
    }

    private func loadPets(all: [Species], selected: [Species], tag: String?) {
        selectedSpecies = selected
        unselectedSpecies = all.filter { tag == nil || $0.tags.contains(tag ?? "") }
    }
}
