import NotAGif
import Pets
import SwiftUI
import Tracking
import Yage

class PetDetailsViewModel: ObservableObject {
    @Binding var isShown: Bool
    
    let species: Species
    
    var appState: AppState { AppState.global }
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected }

    var isSelected: Bool { appState.speciesOnStage.value.contains(species) }
    var title: String { species.name }

    var animationFrames: [ImageFrame] {
        PetsAssetsProvider.shared.images(for: species.id, animation: "front")
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
    
    func export() {
        PetsExporter.shared.export(species: species) { destination in
            guard let destination else { return }
            NSWorkspace.shared.open(destination)
        }
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
