import DesignSystem
import InAppPurchases
import Lang
import NotAGif
import Pets
import Schwifty
import Squanch
import SwiftUI
import Tracking

struct PetDetails: View {
    
    @StateObject var viewModel: PetDetailsViewModel
    
    @EnvironmentObject var pricing: PricingService
    
    init(isShown: Binding<Bool>, pet: Pet) {
        let vm = PetDetailsViewModel(isShown: isShown, pet: pet)
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(spacing: .xl) {
            Text(viewModel.title).font(.largeTitle.bold())
            AnimatedPreview()
            About().padding(.top, .lg)
            Footer()
        }
        .padding(.lg)
        .frame(width: 450)
        .environmentObject(viewModel)
        .onAppear {
            let species = viewModel.pet.id
            Tracking.didEnterDetails(
                species: species,
                name: viewModel.pet.name,
                price: pricing.price(for: species)?.doublePrice,
                purchased: pricing.didPay(for: species)
            )
        }
    }
}

private struct About: View {
    
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        Text(viewModel.pet.about)
            .lineLimit(5)
            .multilineTextAlignment(.center)
    }
}

private struct AnimatedPreview: View {
    
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        ZStack {
            AnimatedContent(frames: viewModel.animationFrames, fps: viewModel.animationFps) { imageFrame in
                Image(frame: imageFrame)
                    .pixelArt()
                    .frame(width: 150, height: 150)
            }
        }
        .frame(width: 150, height: 150)
    }
}

private struct Footer: View {
    
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        HStack {
            Button(Lang.cancel, action: viewModel.close)
                .buttonStyle(.text)
            
            if viewModel.canSelect {
                Button(Lang.PetSelection.addPet, action: viewModel.select)
                    .buttonStyle(.regular)
            }
            if viewModel.canRemove {
                Button(Lang.remove, action: viewModel.remove)
                    .buttonStyle(.regular)
            }
            if viewModel.canBuy {
                Button(viewModel.buyTitle, action: viewModel.buy)
                    .buttonStyle(.regular)
            }
        }
    }
}
