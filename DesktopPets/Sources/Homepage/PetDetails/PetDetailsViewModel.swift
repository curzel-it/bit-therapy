import InAppPurchases
import OnScreen
import NotAGif
import Pets
import SwiftUI
import Tracking
import Yage

class PetDetailsViewModel: ObservableObject {
    @Binding var isShown: Bool
    @Published var buyTitle: String = ""
    
    let pet: Pet
    
    var title: String { pet.name }
    
    var pricing: PricingService { PricingService.global }
    var isSelected: Bool { AppState.global.selectedPets.contains(pet.id) }
    var isFree: Bool { !pet.isPaid }
    var hasBeenPaid: Bool { pricing.didPay(for: pet.id) }
    var canSelect: Bool { !isSelected && (isFree || hasBeenPaid) }
    var canRemove: Bool { isSelected }
    var canBuy: Bool { !isFree && !hasBeenPaid }
    var price: PetPrice? { pricing.price(for: pet.id) }
    
    var animationFrames: [ImageFrame] {
        let name = PetAnimationPathsProvider().frontAnimationPath(for: pet)
        return PetsAssets.frames(for: name)
    }
    
    var animationFps: TimeInterval {
        max(3, pet.fps)
    }
        
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
        AppState.global.selectedPets.append(pet.id)
        OnScreen.show(with: AppState.global)
        Tracking.didSelect(pet)
        close()
    }
    
    func remove() {
        AppState.global.selectedPets.removeAll { $0 == pet.id }
        OnScreen.show(with: AppState.global)
        Tracking.didRemove(pet)
        close()
    }
    
    func buy() {
        guard let item = pricing.price(for: pet.id) else {
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
