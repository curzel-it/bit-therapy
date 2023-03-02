import CustomPets
import DependencyInjectionUtils
import DesignSystem
import Foundation
import Schwifty
import SwiftUI

class RenamePetButtonCoordinator {
    func view(for speciesId: String) -> AnyView {
        let vm = RenamePetButtonViewModel(speciesId: speciesId)
        return AnyView(
            RenamePetButton(viewModel: vm)
        )
    }
}

private struct RenamePetButton: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: RenamePetButtonViewModel
    
    var body: some View {
        IconButton(systemName: viewModel.icon, action: viewModel.startRenaming)
            .sheet(isPresented: $viewModel.isRenaming) {
                VStack(alignment: .center, spacing: .xl) {
                    Text(Lang.CustomPets.setNameTitle)
                        .font(.largeTitle)
                        .padding(.top)
                    Text(Lang.CustomPets.setNameMessage)
                        .font(.body)
                        .multilineTextAlignment(.center)
                    
                    TextField("", text: $viewModel.name)
                    
                    HStack {
                        Button(Lang.cancel, action: viewModel.cancel)
                            .buttonStyle(.text)
                        Button(Lang.done, action: viewModel.confirm)
                            .buttonStyle(.regular)
                    }
                }
                .padding()
                .frame(width: 450)
            }
    }
}

private class RenamePetButtonViewModel: ObservableObject {
    @Inject var assets: PetsAssetsProvider
    @Inject var names: SpeciesNamesRepository
    
    @Published var isRenaming = false
    @Published var name: String = ""
    
    let icon = "character.cursor.ibeam"
    private let speciesId: String
    
    init(speciesId: String) {
        self.speciesId = speciesId
        self.name = names.currentName(forSpecies: speciesId)
    }
    
    func cancel() {
        isRenaming = false
        name = names.currentName(forSpecies: speciesId)
    }
    
    func startRenaming() {
        isRenaming = true
    }
    
    func confirm() {
        AppState.global.rename(species: speciesId, to: name)
        cancel()
    }
}
