import Pets
import PetsSelection
import SwiftUI
import Yage

class PetsSelectionCoordinator {
    static func view() -> some View {
        PetsSelection.PetsSelectionCoordinator.view(
            localizedContent: LocalizedContent(),
            speciesProvider: AppState.global
        )
    }
}

extension AppState: PetsProvider {
    func add(species: Species) {
        selectedSpecies.append(species.id)
    }
}

private struct LocalizedContent: LocalizedContentProvider {
    var addPet: String { Lang.PetSelection.addPet }
    var cancel: String { Lang.cancel }
    var loading: String { Lang.loading }
    var morePets: String { Lang.PetSelection.morePets }
    var remove: String { Lang.remove }
    var screen: String { Lang.screen }
    var somethingWentWrong: String { Lang.somethingWentWrong }
    var title: String { Lang.Page.home }
    var yourPets: String { Lang.PetSelection.yourPets }

    func description(of species: Species) -> String {
        species.about
    }

    func name(of species: Species) -> String {
        species.name
    }
}
