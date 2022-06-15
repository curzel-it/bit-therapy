//
// Pet Therapy.
//

import DesignSystem
import Pets
import SwiftUI

public struct PetPriceView: View {
        
    @EnvironmentObject var pricing: PricingService
    
    let species: Pet
    
    var price: PetPrice? { pricing.price(for: species) }
    var purchased: Bool { pricing.didPay(for: species) }
    var isShown: Bool { price != nil && !purchased }
    var formattedPrice: String { price?.formattedPrice ?? "" }
    
    let height: CGFloat = 22
    
    public init(species: Pet) {
        self.species = species
    }
    
    public var body: some View {
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
