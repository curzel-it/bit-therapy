import AppState
import Combine
import DesignSystem
import InAppPurchases
import Pets
import Schwifty
import Squanch
import SwiftUI

struct PetGridItem: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: PetSelectionViewModel
    
    let pet: Pet
    
    var isSelected: Bool { appState.selectedPets.contains(pet.id) }
    
    var body: some View {
        ZStack {
            PetPreview(pet: pet)
            SelectionIndicator(isSelected: isSelected)
            PetPriceOverlay(speciesId: pet.id)
        }
    }
}

private struct PetPreview: View {
    
    @EnvironmentObject var viewModel: PetSelectionViewModel
    
    let pet: Pet
    
    var frame: NSImage? {
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
                .font(.regular, .lg)
                .foregroundColor(.label)
                .shadow(radius: 4)
                .positioned(.top)
        }
    }
}
