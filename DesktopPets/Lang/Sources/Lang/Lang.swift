//
// Pet Therapy.
//

import Foundation
import Pets

public class Lang {
    
    // MARK: - Generic
    
    public static let cancel = "cancel".localized()
    public static let select = "select".localized()
    public static let enable = "enable".localized()
    public static let disable = "disable".localized()
    public static let loading = "loading".localized()
    public static let done = "done".localized()
    public static let somethingWentWrong = "somethingWentWrong".localized()
    
    // MARK: - Settings
    
    public class Settings {
        
        public static let gravity = "settings.gravity".localized()
        public static let size = "settings.size".localized()
        public static let launchAtLogin = "settings.launchAtLogin".localized()
        public static let statusBarIconEnabled = "settings.statusBarIconEnabled".localized()
        public static let anonymousTracking = "settings.anonymousTracking".localized()
        public static let anonymousTrackingExplainedTitle = "settings.anonymousTracking.title".localized()
        public static let anonymousTrackingExplained = "settings.anonymousTracking.message".localized()
        public static let speed = "settings.speed".localized()
        public static let restorePurchases = "settings.restorePurchases".localized()
    }
    
    // MARK: - About
    
    public class About {
        
        public static let leaveReviewMessage = "about.leaveReviewMessage".localized()
        public static let leaveReview = "about.leaveReview".localized()
        public static let joinRedditMessage = "about.joinRedditMessage".localized()
        public static let joinReddit = "about.joinReddit".localized()
        public static let mailMessage = "about.mailMessage".localized()
        public static let mail = "about.mail".localized()
        public static let privacyPolicy = "about.privacyPolicy".localized()
    }
    
    // MARK: - Pet Selection
    
    public class PetSelection {
        
        public static let showPet = "petSelection.showPet".localized()
    }
    
    // MARK: - Purchases
    
    public class Purchases {
        
        public static let buy = "purchases.buy".localized()
        public static let buyFor = "purchases.buyFor".localized()
        public static let purchasing = "purchases.purchasing".localized()
        public static let purchased = "purchases.purchased".localized()
    }
}

// MARK: - Pets

extension Pet {
    
    public var name: String { "pet.name.\(id)".localized() }
    public var about: String { "pet.about.\(id)".localized() }
}

// MARK: - Utils

extension String {

    public func localized(in bundle: Bundle = .main) -> String {
        NSLocalizedString(self, bundle: bundle, comment: self)
    }
}

