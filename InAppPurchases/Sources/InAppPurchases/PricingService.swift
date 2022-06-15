//
// Pet Therapy.
//

import Foundation
import Pets
import SwiftUI

public class PricingService: ObservableObject {
        
    public static let global = PricingService()
    
    // MARK: - Setup
    
    public func setup() {
        // ...
    }
    
    // MARK: - Restore
    
    func restorePurchases() async -> Bool {
        return true
    }
    
    // MARK: - Buy
    
    public func buy(_ item: PetPrice) async -> Bool {
        return true
    }
    
    // MARK: - Purchases
    
    public func didPay(for species: Pet) -> Bool {
        return false
    }
    
    public func price(for species: Pet) -> PetPrice? {
        return nil
    }
}

// MARK: - Prices

public struct PetPrice {
    
    public var price: Decimal { 0 }
    
    public var formattedPrice: String? { nil }
}
