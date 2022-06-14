//
// Pet Therapy.
//

import DesignSystem
import SwiftUI

struct PetPriceView: View {
    
    @EnvironmentObject var viewModel: PetSelectionViewModel
    
    @EnvironmentObject var pricing: PricingService
    
    let species: Pet
    
    var price: PetPrice? { pricing.prices[species.id] }
    
    var purchased: Bool { false }
    
    var isShown: Bool { price != nil && !purchased }
    
    var formattedPrice: String { price?.formattedPrice ?? "" }
    
    let height: CGFloat = 22
    
    var body: some View {
        if isShown {
            Text(formattedPrice)
                .font(.regular, .sm)
                .padding(.xs)
                .frame(height: height)
                .background(Color.paidBanner)
                .foregroundColor(.white)
                .cornerRadius(height/2)
                .rotationEffect(.radians(.pi * 0.05))
        }
    }
}
