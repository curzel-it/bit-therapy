import Pets
import PetsSelection
import SwiftUI
import Yage

class PetsSelectionCoordinator {
    static func view() -> some View {
        PetsSelection.PetsSelectionCoordinator.view(
            localizedContent: LocalizedContent(),
            speciesProvider: AppState.global,
            footer: AnyView(
                RequestPetsViaSurvey()
                    .padding(.vertical, .xl)
            )
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
    var purchasing: String { Lang.Purchases.purchasing }
    var purchased: String { Lang.Purchases.purchased }
    var remove: String { Lang.remove }
    var somethingWentWrong: String { Lang.somethingWentWrong }
    var title: String { Lang.Page.home }
    var yourPets: String { Lang.PetSelection.yourPets }

    func buyButtonTitle(formattedPrice: String) -> String {
        "\(Lang.Purchases.buyFor) \(formattedPrice)"
    }

    func description(of species: Species) -> String {
        species.about
    }

    func name(of species: Species) -> String {
        species.name
    }
}
