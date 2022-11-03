import Combine
import DesignSystem
import InAppPurchases
import Pets
import Schwifty
import SwiftUI
import Yage

// MARK: - Grid

struct PetsGrid: View {
    let title: String
    let columns: [GridItem]
    let pets: [Pet]
    
    var body: some View {
        VStack(spacing: 0) {
            Title(title: title)
            LazyVGrid(columns: columns, spacing: Spacing.xl.rawValue) {
                ForEach(pets) {
                    Item(pet: $0)
                }
            }
        }
    }
}

// MARK: - Grid Item

private struct Item: View {
    @EnvironmentObject var appState: AppState
    
    let pet: Pet
    var isSelected: Bool { appState.selectedPets.contains(pet.id) }
    
    var body: some View {
        ZStack {
            Preview(pet: pet)
            PetPriceOverlay(speciesId: pet.id)
        }
    }
}

// MARK: - Item Preview

private struct Preview: View {
    @EnvironmentObject var viewModel: HomepageViewModel
    
    let pet: Pet
    
    var frame: ImageFrame? {
        let name = PetAnimationPathsProvider().frontAnimationPath(for: pet)
        return PetsAssets.frames(for: name).first
    }
    
    var body: some View {
        if let frame = frame {
            Image(frame: frame)
                .pixelArt()
                .frame(width: 80, height: 80)
                .padding(.top, 20)
                .onTapGesture { viewModel.showDetails(of: pet) }
        }
    }
}

// MARK: - Grid Title

private struct Title: View {
    let title: String
    
    var body: some View {
        Text(title)
            .textAlign(.leading)
            .font(.title2, when: .macOS)
            .font(.title2.bold(), when: .iOS)
    }    
}
