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
                NewsView()
                MyPets()
                MorePets().padding(.bottom, .xxl)
                PetsImporterDragAndDropView().padding(.bottom, .xxl)
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

private struct MyPets: View {
    @EnvironmentObject var viewModel: PetsSelectionViewModel
    
    var body: some View {
        VStack(spacing: .md) {
            Title(text: Lang.PetSelection.yourPets)
            PetsGrid(
                columns: viewModel.gridColums,
                species: viewModel.speciesOnStage
            )
        }
    }
}

private struct MorePets: View {
    @EnvironmentObject var viewModel: PetsSelectionViewModel

    var body: some View {
        VStack(spacing: .md) {
            Title(text: Lang.PetSelection.morePets)
            HStack {
                VStack {
                    FiltersView().frame(width: 150)
                    Spacer()
                }
                VStack {
                    PetsGrid(
                        columns: viewModel.gridColums,
                        species: viewModel.unselectedSpecies
                    )
                    Spacer()
                }
            }
        }
    }
}

private struct Title: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title.bold())
            .textAlign(.leading)
    }
}
