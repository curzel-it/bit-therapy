import Pets
import SwiftUI

public protocol PetDetailsManager {
    var isSelected: Bool { get }
    var isShown: Binding<Bool> { get set }
    var pet: Pet { get }
    
    func didSelect()
    func didRemove()
}

public protocol LocalizedContentProvider {
    func buyButtonTitle(formattedPrice: String) -> String
    func description(of pet: Pet) -> String
    func name(of pet: Pet) -> String
    func translation(for: LocalizableKey) -> String
}

public enum LocalizableKey {
    case addPet
    case cancel
    case loading
    case purchasing
    case purchased
    case remove
    case somethingWentWrong
}

public class PetDetailsViewCoordinator {
    public static func view(
        managedBy manager: PetDetailsManager,
        localizedContent lang: LocalizedContentProvider
    ) -> some View {
        let viewModel = PetDetailsViewModel(managedBy: manager, localizedContent: lang)
        return PetDetailsView(viewModel: viewModel)
    }
}
