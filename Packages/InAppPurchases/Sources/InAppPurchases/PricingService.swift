//
// Pet Therapy.
//

import Foundation
import RevenueCat
import SwiftUI

public class PricingService: ObservableObject {
    
    public static let global = PricingService()
    
    private var isAvailable = false
    
    @Published var prices: Prices = [:]
    
    @Published private(set) var purchased: [String] = [] {
        didSet {
            cachedPurchases = purchased.joined(separator: ",")
        }
    }
    
    @AppStorage("commaSeparatedPurchases") private var cachedPurchases: String = ""
    
    // MARK: - Setup
    
    public func setup() {
        if let apiKey = revenueCatApiKey() {
            Purchases.configure(withAPIKey: apiKey)
            Purchases.logLevel = .warn
            isAvailable = true
        }
        purchased = cachedPurchases.components(separatedBy: ",")
        Task { await loadPrices() }
    }
    
    private func revenueCatApiKey() -> String? {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let props = try? NSDictionary(contentsOf: url, error: ()),
            let apiKey = props["RevenueCatApiKey"] as? String
        else { return nil }
        return apiKey
    }
    
    // MARK: - Load Prices
    
    private func loadPrices() async {
        guard isAvailable, prices.count == 0 else { return }
        guard let offerings = try? await Purchases.shared.offerings() else { return }
        guard let offering = offerings.current else { return }
        
        Task { @MainActor in
            withAnimation {
                prices = prices(from: offering)
            }
        }
    }
    
    private func prices(from offering: Offering) -> Prices {
        var newPrices: Prices = [:]
        offering.availablePackages.forEach { package in
            let price = PetPrice(offering: offering, package: package)
            newPrices[price.speciesId] = price
        }
        return newPrices
    }
    
    // MARK: - Restore
    
    func restorePurchases() async -> Bool {
        guard isAvailable else { return false }
        guard let info = try? await Purchases.shared.restorePurchases() else { return false }
        
        let purchasedSpecies = info.entitlements.active.map {
            $0.key.replacingOccurrences(of: "b_", with: "")
        }
        Task { @MainActor in
            withAnimation {
                purchased = purchasedSpecies
            }
        }
        return true
    }
    
    // MARK: - Buy
    
    public func buy(_ item: PetPrice) async -> Bool {
        guard isAvailable else { return false }
        
        let result = try? await Purchases.shared.purchase(package: item.package)
        let entitlements = result?.customerInfo.entitlements
        let key = item.package.storeProduct.productIdentifier
        let succeed = entitlements?[key]?.isActive ?? false
        
        if succeed {
            withAnimation {
                purchased.append(item.speciesId)
            }
        }
        return succeed
    }
    
    // MARK: - Purchases
    
    public func didPay(for species: String) -> Bool {
        guard isAvailable else { return true }
        return purchased.contains(species)
    }
    
    public func price(for species: String) -> PetPrice? {
        guard isAvailable else { return nil }
        return prices[species]
    }
}

// MARK: - Prices

public typealias Prices = [String: PetPrice]

public struct PetPrice {
    
    let offering: Offering
    let package: Package
    
    var speciesId: String {
        package
            .storeProduct.productIdentifier
            .replacingOccurrences(of: "b_", with: "")
    }
    
    public var price: Decimal {
        package.storeProduct.price
    }
    
    public var doublePrice: Double {
        NSDecimalNumber(
            decimal: package.storeProduct.price
        ).doubleValue
    }
    
    public var formattedPrice: String? {
        let decimal = NSDecimalNumber(decimal: price)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: decimal)
    }
    
    init(offering: Offering, package: Package) {
        self.offering = offering
        self.package = package
    }
}
