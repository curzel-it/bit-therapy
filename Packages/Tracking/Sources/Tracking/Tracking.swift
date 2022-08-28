import Firebase
import FirebaseAnalytics
import Lang
import Pets
import Squanch

// MARK: - Setup

public struct Tracking {
    
    public static var isEnabled = false
    
    public static func setup(isEnabled: Bool) {
        let firebaseAvailable = FirebaseApp.setup()
        self.isEnabled = isEnabled && firebaseAvailable
    }
}

// MARK: - Events

extension Tracking {
    
    public static func didLaunchApp(
        gravityEnabled: Bool,
        petSize: CGFloat,
        launchAtLogin: Bool,
        selectedPet: String
    ) {
        log(AnalyticsEventAppOpen, with: [
            "gravity_enabled": gravityEnabled,
            "pet_size": petSize,
            "launch_at_login": launchAtLogin,
            "selected_pet": selectedPet
        ])
    }
    
    public static func didRestorePurchases() {
        log("did_restore_purchases")
    }
    
    public static func didSelect(_ pet: Pet) {
        log("did_select_pet", with: ["pet": pet.id])
    }
    
    public static func didEnterDetails(species: String, name: String, price: Double?, purchased: Bool) {
        log(AnalyticsEventViewItem, with: [
            AnalyticsParameterItemID: species,
            AnalyticsParameterItemName: name,
            AnalyticsParameterPrice: price ?? 0,
            "alreadyPurchased": price == nil || purchased
        ])
    }
    
    public static func purchased(pet: Pet, price: Double, success: Bool) {
        log(AnalyticsEventPurchase, with: [
            AnalyticsParameterItemID: pet.id,
            AnalyticsParameterItemName: pet.name,
            AnalyticsParameterPrice: price,
            AnalyticsParameterSuccess: success
        ])
    }
}
