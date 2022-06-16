//
// Pet Therapy.
//

import DesignSystem
import InAppPurchases
import Lang
import PetEntity
import Physics
import Schwifty
import Squanch
import SwiftUI
import Tracking

struct PetDetails: View {
    
    @StateObject var viewModel: PetDetailsViewModel
    
    @EnvironmentObject var pricing: PricingService
    
    init(isShown: Binding<Bool>, child: PetEntity) {
        self._viewModel = StateObject(
            wrappedValue: PetDetailsViewModel(
                isShown: isShown, child: child
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 80) {
            Text(viewModel.title).font(.bold, .xl)
            Preview()
            About()
            Footer()
        }
        .padding(.lg)
        .frame(width: 450)
        .environmentObject(viewModel)
        .onAppear {
            let species = viewModel.child.species
            Tracking.didEnterDetails(
                of: species,
                price: pricing.price(for: species)?.doublePrice ?? 0,
                purchased: pricing.didPay(for: species)
            )
        }
    }
}

private struct About: View {
    
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        Text(viewModel.child.species.about)
            .lineLimit(5)
            .multilineTextAlignment(.center)
            .font(.regular, .md)
    }
}

private struct Preview: View {
    
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        ZStack {
            EntityView(child: viewModel.child)
            PetPriceOverlay(species: viewModel.child.species)
        }
        .scaleEffect(1.5)
    }
}

private struct Footer: View {
    
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        HStack {
            Button(Lang.cancel, action: viewModel.close)
                .buttonStyle(.text)
            
            if viewModel.canSelect {
                Button(Lang.select, action: viewModel.select)
                    .buttonStyle(.regular)
            }
            
            if viewModel.canBuy {
                Button(viewModel.buyTitle, action: viewModel.buy)
                    .buttonStyle(.regular)
            }
        }
    }
}
