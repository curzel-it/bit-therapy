// 
// Pet Therapy.
// 

import AppState
import Lang
import InAppPurchases
import OnScreen
import Pets
import SwiftUI
import Tracking

class PetDetailsViewModel: ObservableObject {
    
    @Binding var isShown: Bool
    
    @Published var buyTitle: String = ""
    
    let pet: Pet
    
    var title: String { pet.name }
    
    var pricing: PricingService { PricingService.global }
    var isFree: Bool { !pet.isPaid }
    var hasBeenPaid: Bool { pricing.didPay(for: pet) }
    var canSelect: Bool { isFree || hasBeenPaid }
    var canBuy: Bool { !isFree && !hasBeenPaid }
    var price: PetPrice? { pricing.price(for: pet) }
        
    init(isShown: Binding<Bool>, pet: Pet) {
        self._isShown = isShown
        self.pet = pet
        
        if let formatted = price?.formattedPrice {
            animateBuyTitle("\(Lang.Purchases.buyFor) \(formatted)")
        } else {
            animateBuyTitle("")
        }
    }
 
    func close() {
        withAnimation {
            isShown = false
        }
    }
    
    func select() {
        AppState.global.selectedPet = pet.id
        OnScreen.show()
        Tracking.didSelect(pet)
        close()
    }
    
    func buy() {
        guard let item = pricing.price(for: pet) else {
            Tracking.purchased(pet: pet, price: -1, success: false)
            return
        }
        animateBuyTitle(Lang.Purchases.purchasing)        
        
        Task {
            let succeed = await PricingService.global.buy(item)
            Tracking.purchased(
                pet: pet,
                price: item.doublePrice,
                success: succeed
            )
            
            Task { @MainActor in
                if succeed {
                    animateBuyTitle(Lang.Purchases.purchased)
                } else {
                    animateBuyTitle(Lang.somethingWentWrong)
                    animateBuyTitle(Lang.loading, delay: 2)
                }
            }
        }
    }
    
    func animateBuyTitle(_ value: String, delay: TimeInterval=0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            withAnimation {
                self?.buyTitle = value
            }
        }
    }
}
