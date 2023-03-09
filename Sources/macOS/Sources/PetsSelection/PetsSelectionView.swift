import Schwifty
import SwiftUI

struct PetsSelectionView: View {
    @StateObject var viewModel: PetsSelectionViewModel

    init() {
        self._viewModel = StateObject(wrappedValue: PetsSelectionViewModel())
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                NewsView()
                VStack(spacing: .xxl) {
                    MyPets()
                    MorePets().padding(.bottom, .xl)
                    viewModel.importView().padding(.bottom, .xxxxl)
                }
            }
            .padding(.md)
        }
        .sheet(isPresented: viewModel.showingDetails) {
            if let species = viewModel.openSpecies {
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
            HStack {
                Title(text: Lang.PetSelection.yourPets)
                if DeviceRequirement.macOS.isSatisfied {
                    JoinOurDiscord()
                }
            }
            PetsGrid(
                columns: viewModel.gridColums,
                species: viewModel.selectedSpecies
            )
        }
    }
}

private struct MorePets: View {
    @EnvironmentObject var viewModel: PetsSelectionViewModel

    var body: some View {
        VStack(spacing: .md) {
            Title(text: Lang.PetSelection.morePets)
            if DeviceRequirement.macOS.isSatisfied || DeviceRequirement.iPad.isSatisfied {
                GridAndFiltersSideToSide()
            } else {
                GridAndFiltersVerticallyStacked()
            }
        }
    }
}

private struct GridAndFiltersVerticallyStacked: View {
    @EnvironmentObject var viewModel: PetsSelectionViewModel
    
    var body: some View {
        VStack(spacing: .lg) {
            HorizontalFiltersView()
            PetsGrid(
                columns: viewModel.gridColums,
                species: viewModel.unselectedSpecies
            )
            Spacer()
        }
    }
}

private struct GridAndFiltersSideToSide: View {
    @EnvironmentObject var viewModel: PetsSelectionViewModel
    
    var body: some View {
        HStack {
            VStack {
                PetsGrid(
                    columns: viewModel.gridColums,
                    species: viewModel.unselectedSpecies
                )
                Spacer()
            }
            .frame(minWidth: nil)
            .frame(maxWidth: .infinity)
            VStack {
                VerticalFiltersView().frame(width: 150)
                Spacer()
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
