//
// Pet Therapy.
//

import Combine
import DesignSystem
import InAppPurchases
import Pets
import Physics
import Squanch
import SwiftUI
import Schwifty

struct PetGridItem: View {
    
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var viewModel: PetSelectionViewModel
    
    let pet: SelectablePet
    
    var isSelected: Bool { appState.selectedPet == pet.species }
    
    var body: some View {
        ZStack {
            EntityView(child: pet)
                .padding(.top, 20)
                .onTapGesture { viewModel.showDetails(of: pet) }
            
            SelectionIndicator(isSelected: isSelected)
            PetPriceOverlay(species: pet.species)
        }
    }
}

private struct SelectionIndicator: View {
    
    let isSelected: Bool
    
    @State var isAnimating: Bool = false
    
    var body: some View {
        if isSelected {
            Image(systemName: "arrowtriangle.down.fill")
                .font(.regular, .lg)
                .foregroundColor(.label)
                .shadow(radius: 4)
                .offset(y: isAnimating ? 4 : 0)
                .animation(.default.repeatForever(), value: isAnimating)
                .onAppear { isAnimating = true }
                .positioned(.top)
        }
    }
}

public struct PetPriceOverlay: View {
    
    let species: Pet
    
    var pricing: PricingService { PricingService.global }
    var isFree: Bool { !species.isPaid }
    var hasBeenPaid: Bool { pricing.didPay(for: species) }
    var canBuy: Bool { !isFree && !hasBeenPaid }
    
    public var body: some View {
        if canBuy {
            PetPriceView(species: species)
                .positioned(.bottom)
                .offset(x: -20)
                .offset(y: 8)
        }
    }
}
