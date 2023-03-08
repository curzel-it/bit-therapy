import Combine
import NotAGif
import Schwifty
import SwiftUI
import Yage

protocol PetDetailsHeaderBuilder {
    func build(with viewModel: PetDetailsViewModel) -> AnyView
}

class PetDetailsViewModel: ObservableObject {
    @Inject private var appState: AppState
    @Inject private var assets: PetsAssetsProvider
    @Inject private var names: SpeciesNamesRepository
    @Inject private var headerBuilder: PetDetailsHeaderBuilder
    
    @Binding var isShown: Bool
    @Published var title: String = ""
    
    let species: Species
    let speciesAbout: String
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected }
    var isSelected: Bool { appState.isSelected(species.id) }

    var animationFrames: [ImageFrame] {
        assets.images(for: species.id, animation: "front")
    }

    var animationFps: TimeInterval {
        max(3, species.fps)
    }
    
    private var disposables = Set<AnyCancellable>()

    init(isShown: Binding<Bool>, species: Species) {
        self._isShown = isShown
        self.speciesAbout = Lang.Species.about(for: species.id)
        self.species = species
        self.bindTitle()
    }
    
    func close() {
        withAnimation {
            isShown = false
        }
    }

    func selected() {
        appState.select(species.id)
        Tracking.didSelect(species.id)
        close()
    }

    func remove() {
        appState.deselect(species.id)
        Tracking.didRemove(species.id)
        close()
    }
    
    func didAppear() {
        Tracking.didEnterDetails(
            species: species.id,
            name: species.id,
            price: nil,
            purchased: false
        )
    }
    
    private func bindTitle() {
        names.name(forSpecies: species.id)
            .sink { [weak self] name in self?.title = name }
            .store(in: &disposables)
    }
}
