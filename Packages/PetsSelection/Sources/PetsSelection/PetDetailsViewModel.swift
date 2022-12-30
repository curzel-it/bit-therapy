import NotAGif
import Pets
import SwiftUI
import Tracking
import Yage

class PetDetailsViewModel: ObservableObject {
    @Binding var isShown: Bool
    
    let species: Species
    let lang: LocalizedContentProvider
    let assetsProvider: AssetsProvider
    let speciesProvider: PetsProvider
    
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected }

    var isSelected: Bool { speciesProvider.speciesOnStage.value.contains(species) }
    var title: String { lang.name(of: species) }

    var animationFrames: [ImageFrame] {
        assetsProvider
            .frames(for: species.id, animation: "front")
            .compactMap { assetsProvider.image(sprite: $0) }
    }

    var animationFps: TimeInterval {
        max(3, species.fps)
    }

    init(
        isShown: Binding<Bool>,
        species: Species,
        speciesProvider: PetsProvider,
        localizedContent: LocalizedContentProvider,
        assetsProvider: AssetsProvider
    ) {
        self._isShown = isShown
        self.species = species
        self.assetsProvider = assetsProvider
        self.lang = localizedContent
        self.speciesProvider = speciesProvider
    }

    func close() {
        withAnimation {
            isShown = false
        }
    }

    func selected() {
        speciesProvider.add(species: species)
        speciesProvider.speciesOnStage.send(speciesProvider.speciesOnStage.value + [species])
        Tracking.didSelect(species.id)
        close()
    }

    func remove() {
        speciesProvider.remove(species: species)
        speciesProvider.speciesOnStage.send(speciesProvider.speciesOnStage.value.filter { $0 != species })
        Tracking.didRemove(species.id)
        close()
    }
}

extension NSScreen: Identifiable {
    public var id: String { localizedName.lowercased() }
}
