import InAppPurchases
import NotAGif
import Pets
import PetsAssets
import SwiftUI
import Tracking
import Yage

class PetDetailsViewModel: ObservableObject {
    @Published var buyTitle: String = ""

    var lang: LocalizedContentProvider
    var manager: PetDetailsManager

    var canBuy: Bool { !isFree && !hasBeenPaid }
    var canRemove: Bool { isSelected }
    var canSelect: Bool { !isSelected && (isFree || hasBeenPaid) }

    var isFree: Bool { !species.isPaid }
    var isSelected: Bool { manager.isSelected }
    var hasBeenPaid: Bool { pricing.didPay(for: species.id) }
    var species: Species { manager.species }
    var price: PetPrice? { pricing.price(for: species.id) }
    var pricing: PricingService { PricingService.global }
    var title: String { lang.name(of: species) }

    var animationFrames: [ImageFrame] {
        PetsAssetsProvider.shared
            .frames(for: species.id, animation: "front")
            .compactMap { PetsAssetsProvider.shared.image(sprite: $0) }
    }

    var animationFps: TimeInterval {
        max(3, species.fps)
    }

    init(managedBy manager: PetDetailsManager, localizedContent: LocalizedContentProvider) {
        lang = localizedContent
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
        Tracking.didSelect(species.id)
        close()
    }

    func remove() {
        manager.didRemove()
        Tracking.didRemove(species.id)
        close()
    }

    func buy() {
        guard let item = pricing.price(for: species.id) else {
            Tracking.purchased(species: species.id, price: -1, success: false)
            return
        }
        animateBuyTitle(lang.purchasing)

        Task {
            let succeed = await PricingService.global.buy(item)
            Tracking.purchased(
                species: species.id,
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

    func animateBuyTitle(_ value: String, delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            withAnimation {
                self?.buyTitle = value
            }
        }
    }
}
