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
    var addPet: String { get }
    var cancel: String { get }
    var loading: String { get }
    var purchasing: String { get }
    var purchased: String { get }
    var remove: String { get }
    var somethingWentWrong: String { get }
    
    func buyButtonTitle(formattedPrice: String) -> String
    func description(of pet: Pet) -> String
    func name(of pet: Pet) -> String
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
