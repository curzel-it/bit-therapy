import Pets
import SwiftUI
import Yage

public protocol PetDetailsManager {
    var isSelected: Bool { get }
    var species: Species { get }

    func close()
    func didSelect()
    func didRemove()
}

public protocol LocalizedContentProvider {
    var addPet: String { get }
    var cancel: String { get }
    var loading: String { get }
    var remove: String { get }
    var screen: String { get }
    var somethingWentWrong: String { get }

    func description(of species: Species) -> String
    func name(of species: Species) -> String
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
