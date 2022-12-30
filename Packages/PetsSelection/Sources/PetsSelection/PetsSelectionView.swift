import DesignSystem
import Schwifty
import SwiftUI

struct PetsSelectionView: View {
    @StateObject var viewModel: PetsSelectionViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .xxl) {
                if DeviceRequirement.iOS.isSatisfied {
                    Text(viewModel.localizedContent.title).title()
                }
                PetsGrid(
                    title: viewModel.localizedContent.yourPets,
                    columns: viewModel.gridColums,
                    species: viewModel.speciesOnStage
                )
                PetsGrid(
                    title: viewModel.localizedContent.morePets,
                    columns: viewModel.gridColums,
                    species: viewModel.unselectedSpecies
                )
            }
            .padding(.md)
        }
        .sheet(isPresented: viewModel.showingDetails) {
            if let species = viewModel.selectedSpecies {
                let vm = PetDetailsViewModel(
                    isShown: viewModel.showingDetails,
                    species: species,
                    speciesProvider: viewModel.speciesProvider,
                    localizedContent: viewModel.localizedContent,
                    assetsProvider: viewModel.assetsProvider
                )
                PetDetailsView(viewModel: vm)
            }
        }
        .environmentObject(viewModel)
    }
}
