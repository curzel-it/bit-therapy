import InAppPurchases
import NotAGif
import Pets
import SwiftUI
import Tracking

class PetDetailsViewModel: ObservableObject {
    @Published var buyTitle: String = ""
    
    var lang: LocalizedContentProvider
    var manager: PetDetailsManager
    
    var canBuy: Bool { !isFree && !hasBeenPaid }
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected && (isFree || hasBeenPaid) }
    
    var isFree: Bool { !pet.isPaid }
    var isSelected: Bool { manager.isSelected }
    var hasBeenPaid: Bool { pricing.didPay(for: pet.id) }
    var pet: Pet { manager.pet }
    var price: PetPrice? { pricing.price(for: pet.id) }
    var pricing: PricingService { PricingService.global }
    var title: String { lang.name(of: pet) }
    
    var animationFrames: [ImageFrame] {
        let name = PetAnimationPathsProvider().frontAnimationPath(for: pet)
        return PetsAssets.frames(for: name)
    }
    
    var animationFps: TimeInterval {
        max(3, pet.fps)
    }
    
    init(managedBy manager: PetDetailsManager, localizedContent: LocalizedContentProvider) {
        self.lang = localizedContent
        self.manager = manager
        setupBuyButton()
    }
    
    private func setupBuyButton() {
        if let formatted = price?.formattedPrice {
            animateBuyTitle(lang.buyButtonTitle(formattedPrice: formatted))
        } else {
            animateBuyTitle("")
        }
    }
    
    func close() {
        manager.close()
    }
    
    func select() {
        manager.didSelect()
        Tracking.didSelect(pet)
        close()
    }
    
    func remove() {
        manager.didRemove()
        Tracking.didRemove(pet)
        close()
    }
    
    func buy() {
        guard let item = pricing.price(for: pet.id) else {
            Tracking.purchased(pet: pet, price: -1, success: false)
            return
        }
        animateBuyTitle(lang.purchasing)
        
        Task {
            let succeed = await PricingService.global.buy(item)
            Tracking.purchased(
                pet: pet,
                price: item.doublePrice,
                success: succeed
            )
            
            Task { @MainActor in
                if succeed {
                    animateBuyTitle(lang.purchased)
                } else {
                    animateBuyTitle(lang.somethingWentWrong)
                    animateBuyTitle(lang.loading, delay: 2)
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
