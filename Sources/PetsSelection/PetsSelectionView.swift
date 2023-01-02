import DesignSystem
import Schwifty
import SwiftUI

struct PetsSelectionView: View {
    @StateObject var viewModel: PetsSelectionViewModel

    init() {
        self._viewModel = StateObject(wrappedValue: PetsSelectionViewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xxl) {
                PetsGrid(
                    title: Lang.PetSelection.yourPets,
                    columns: viewModel.gridColums,
                    species: viewModel.speciesOnStage
                )
                PetsGrid(
                    title: Lang.PetSelection.morePets,
                    columns: viewModel.gridColums,
                    species: viewModel.unselectedSpecies
                )
                .padding(.bottom, .xxl)
                
                PetsImporterDragAndDropView()
                    .padding(.bottom, .xxl)
            }
            .padding(.md)
        }
        .sheet(isPresented: viewModel.showingDetails) {
            if let species = viewModel.selectedSpecies {
                PetDetailsView(
                    isShown: viewModel.showingDetails,
                    species: species
                )
            }
        }
        .environmentObject(viewModel)
    }
}
