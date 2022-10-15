import AppState
import Combine
import DesignSystem
import InAppPurchases
import Pets
import Schwifty
import Squanch
import SwiftUI
import Yage

struct PetsGridItem: View {
    
    @EnvironmentObject var appState: AppState
    
    let pet: Pet
    
    var isSelected: Bool { appState.selectedPets.contains(pet.id) }
    
    var body: some View {
        ZStack {
            PetPreview(pet: pet)
            PetPriceOverlay(speciesId: pet.id)
        }
    }
}

private struct PetPreview: View {
    
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

private struct SelectionIndicator: View {
    
    let isSelected: Bool
    
    var body: some View {
        if isSelected {
            Image(systemName: "arrowtriangle.down.fill")
                .font(.title2)
                .foregroundColor(.label)
                .shadow(radius: 4)
                .positioned(.top)
                .padding(.top, 4)
        }
    }
}

struct PetsGridTitle: View {
    
    let title: String
    
    var body: some View {
        Text(title).font(.title2).textAlign(.leading)
    }
}
