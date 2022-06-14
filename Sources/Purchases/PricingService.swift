//
// Pet Therapy.
//

import Foundation
import SwiftUI

class PricingService: ObservableObject {
        
    static let global = PricingService()
    
    @Published var prices: [String: PetPrice] = [:]
    
    @Published private(set) var purchased: [String] = []
    
    // MARK: - Setup
    
    public func setup() {
        // ...
    }
    
    // MARK: - Load Prices
    
    private func loadPrices() async {
        // ...
    }
    
    // MARK: - Restore
    
    func restorePurchases() async -> Bool {
        return true
    }
    
    // MARK: - Buy
    
    func buy(_ item: PetPrice) async -> Bool {
        return true
    }
    
    // MARK: - Purchases
    
    func didPay(for species: Pet) -> Bool {
        return true
    }
}

// MARK: - Prices

struct PetPrice {
    
    var speciesId: String { "" }
    
    var price: Decimal { 0 }
    
    var formattedPrice: String? { nil }
}
