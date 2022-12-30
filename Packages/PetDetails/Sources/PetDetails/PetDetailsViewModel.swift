import NotAGif
import Pets
import PetsAssets
import SwiftUI
import Tracking
import Yage

class PetDetailsViewModel: ObservableObject {
    var lang: LocalizedContentProvider
    var manager: PetDetailsManager
    
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected }

    var isSelected: Bool { manager.isSelected }
    var species: Species { manager.species }
    var title: String { lang.name(of: species) }

    var animationFrames: [ImageFrame] {
        PetsAssetsProvider.shared
            .frames(for: species.id, animation: "front")
            .compactMap { PetsAssetsProvider.shared.image(sprite: $0) }
    }

    var animationFps: TimeInterval {
        max(3, species.fps)
    }

    init(managedBy manager: PetDetailsManager, localizedContent: LocalizedContentProvider) {
        lang = localizedContent
        self.manager = manager
    }

    func close() {
        manager.close()
    }

    func selected() {
        manager.didSelect()
        Tracking.didSelect(species.id)
        close()
    }

    func remove() {
        manager.didRemove()
        Tracking.didRemove(species.id)
        close()
    }
}

extension NSScreen: Identifiable {
    public var id: String { localizedName.lowercased() }
}
