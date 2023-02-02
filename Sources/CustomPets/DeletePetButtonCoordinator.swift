import CustomPets
import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage

class DeletePetButtonCoordinator {
    func view(for species: Species, completion: @escaping (Bool) -> Void) -> AnyView {
        let vm = DeletePetButtonViewModel(species: species, completion: completion)
        return AnyView(
            DeletePetButton(viewModel: vm)
        )
    }
}

private struct DeletePetButton: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: DeletePetButtonViewModel    
    
    var body: some View {
        if viewModel.isEnabled {
            Button(Lang.delete, action: viewModel.delete)
                .buttonStyle(.text)
                .scaleEffect(0.8)
        }
    }
}

private class DeletePetButtonViewModel: ObservableObject {
    @Inject var deletePetUseCase: DeletePetUseCase
    @Inject var assets: PetsAssetsProvider
    
    var isEnabled: Bool {
        !species.isOriginal()
    }
    
    private let species: Species
    private let completion: (Bool) -> Void
    
    init(species: Species, completion: @escaping (Bool) -> Void) {
        self.species = species
        self.completion = completion
    }
    
    func delete() {
        let deleted = deletePetUseCase.safelyDelete(item: species)
        if deleted {
            assets.reloadAssets()
            Species.unregister(species)
        }
        completion(deleted)
    }
}
