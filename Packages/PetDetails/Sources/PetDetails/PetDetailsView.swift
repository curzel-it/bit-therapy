import DesignSystem
import InAppPurchases
import NotAGif
import Pets
import Schwifty
import SwiftUI
import Tracking

struct PetDetailsView: View {
    @StateObject var viewModel: PetDetailsViewModel
    @EnvironmentObject var pricing: PricingService
    
    init(viewModel: PetDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: .xl) {
            Text(viewModel.title).font(.largeTitle.bold())
            AnimatedPreview()
            About().padding(.top, .lg)
            Footer()
        }
        .padding(.lg)
        .onAppear {
            let species = viewModel.pet.id
            Tracking.didEnterDetails(
                species: species,
                name: viewModel.lang.name(of: viewModel.pet),
                price: pricing.price(for: species)?.doublePrice,
                purchased: pricing.didPay(for: species)
            )
        }
        .environmentObject(viewModel)
    }
}

private struct About: View {
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        Text(viewModel.lang.description(of: viewModel.pet))
            .lineLimit(5)
            .multilineTextAlignment(.center)
    }
}

private struct AnimatedPreview: View {
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        ZStack {
            AnimatedContent(frames: viewModel.animationFrames, fps: viewModel.animationFps) { frame in
                Image(frame: frame)
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
            Button(viewModel.lang.translation(for: .cancel), action: viewModel.close)
                .buttonStyle(.text)
            
            if viewModel.canSelect {
                Button(viewModel.lang.translation(for: .addPet), action: viewModel.select)
                    .buttonStyle(.regular)
            }
            if viewModel.canRemove {
                Button(viewModel.lang.translation(for: .remove), action: viewModel.remove)
                    .buttonStyle(.regular)
            }
            if viewModel.canBuy {
                Button(viewModel.buyTitle, action: viewModel.buy)
                    .buttonStyle(.regular)
            }
        }
    }
}
