import DesignSystem
import SwiftUI

public struct PetPriceView: View {
        
    @EnvironmentObject var pricing: PricingService
    
    let speciesId: String
    
    var price: PetPrice? { pricing.price(for: speciesId) }
    var purchased: Bool { pricing.didPay(for: speciesId) }
    var isShown: Bool { price != nil && !purchased }
    var formattedPrice: String { price?.formattedPrice ?? "" }
    
    let height: CGFloat = 22
    
    public init(speciesId: String) {
        self.speciesId = speciesId
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

public struct PetPriceOverlay: View {
    
    let speciesId: String
    
    var pricing: PricingService { PricingService.global }
    var isFree: Bool { pricing.price(for: speciesId) == nil }
    var hasBeenPaid: Bool { pricing.didPay(for: speciesId) }
    var canBuy: Bool { !isFree && !hasBeenPaid }
    
    public init(speciesId: String) {
        self.speciesId = speciesId
    }
    
    public var body: some View {
        if canBuy {
            PetPriceView(speciesId: speciesId)
                .positioned(.bottom)
                .offset(x: -20)
                .offset(y: 8)
        }
    }
}

