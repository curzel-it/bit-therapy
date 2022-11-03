import PetDetails
import Pets
import SwiftUI

class PetDetailsCoordinator {
    static func view(isShown: Binding<Bool>, pet: Pet) -> some View {
        PetDetailsViewCoordinator.view(
            managedBy: DetailsManager(isShown: isShown, pet: pet),
            localizedContent: LocalizedContent()
        )
    }
}

private struct DetailsManager: PetDetailsManager {
    var isShown: Binding<Bool>
    let pet: Pet
    var isSelected: Bool { AppState.global.selectedPets.contains(pet.id) }
    
    func didSelect() {
        AppState.global.selectedPets.append(pet.id)
    }
    
    func didRemove() {
        AppState.global.selectedPets.removeAll { $0 == pet.id }
    }
}

private struct LocalizedContent: LocalizedContentProvider {
    func buyButtonTitle(formattedPrice: String) -> String {
        "\(Lang.Purchases.buyFor) \(formattedPrice)"
    }
    
    func description(of pet: Pet) -> String {
        pet.about
    }
    
    func name(of pet: Pet) -> String {
        pet.name
    }
    
    func translation(for key: LocalizableKey) -> String {
        switch key {
        case .addPet: return Lang.PetSelection.addPet
        case .cancel: return Lang.cancel
        case .loading: return Lang.loading
        case .purchasing: return Lang.Purchases.purchasing
        case .purchased: return Lang.Purchases.purchased
        case .remove: return Lang.remove
        case .somethingWentWrong: return Lang.somethingWentWrong
        }
    }
}
