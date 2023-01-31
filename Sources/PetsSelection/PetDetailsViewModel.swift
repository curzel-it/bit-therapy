import DependencyInjectionUtils
import NotAGif
import SwiftUI
import Yage

class PetDetailsViewModel: ObservableObject {    
    @Inject var assets: PetsAssetsProvider
    
    @Binding var isShown: Bool
    
    let species: Species
    
    var appState: AppState { AppState.global }
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected }

    var isSelected: Bool { appState.selectedSpecies.contains(species) }
    var title: String { species.name }

    var animationFrames: [ImageFrame] {
        assets.images(for: species.id, animation: "front")
    }

    var animationFps: TimeInterval {
        max(3, species.fps)
    }

    init(isShown: Binding<Bool>, species: Species) {
        self._isShown = isShown
        self.species = species
    }

    func close() {
        withAnimation {
            isShown = false
        }
    }

    func selected() {
        appState.add(species: species)
        Tracking.didSelect(species.id)
        close()
    }

    func remove() {
        appState.remove(species: species)
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
}

extension NSScreen: Identifiable {
    public var id: String { localizedName.lowercased() }
}
