import CustomPets
import DependencyInjectionUtils
import DesignSystem
import Foundation
import Schwifty
import SwiftUI
import Yage

class RenamePetButtonCoordinator {
    func view(for species: Species) -> AnyView {
        let vm = RenamePetButtonViewModel(species: species)
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
    
    @Published var isRenaming = false
    @Published var name: String
    
    let icon = "character.cursor.ibeam"
    private let species: Species
    
    init(species: Species) {
        self.species = species
        self.name = species.name
    }
    
    func cancel() {
        isRenaming = false
        name = species.name
    }
    
    func startRenaming() {
        isRenaming = true
    }
    
    func confirm() {
        AppState.global.rename(species, to: name)
        cancel()
    }
}
