// 
// Pet Therapy.
// 

import Foundation

class Lang {
    
    // MARK: - Generic
    
    static let cancel = "cancel".localized()
    static let select = "select".localized()
    static let enable = "enable".localized()
    static let disable = "disable".localized()
    static let loading = "loading".localized()
    static let done = "done".localized()
    static let somethingWentWrong = "somethingWentWrong".localized()
    
    // MARK: - Settings
    
    class Settings {
        
        static let gravity = "settings.gravity".localized()
        static let size = "settings.size".localized()
        static let launchAtLogin = "settings.launchAtLogin".localized()
        static let statusBarIconEnabled = "settings.statusBarIconEnabled".localized()
        static let anonymousTracking = "settings.anonymousTracking".localized()
        static let anonymousTrackingExplainedTitle = "settings.anonymousTracking.title".localized()
        static let anonymousTrackingExplained = "settings.anonymousTracking.message".localized()
        static let speed = "settings.speed".localized()
        static let restorePurchases = "settings.restorePurchases".localized()
    }
    
    // MARK: - About
    
    class About {
        
        static let leaveReviewMessage = "about.leaveReviewMessage".localized()
        static let leaveReview = "about.leaveReview".localized()
        static let joinRedditMessage = "about.joinRedditMessage".localized()
        static let joinReddit = "about.joinReddit".localized()
        static let mailMessage = "about.mailMessage".localized()
        static let mail = "about.mail".localized()
        static let privacyPolicy = "about.privacyPolicy".localized()
    }
    
    // MARK: - Pet Selection
    
    class PetSelection {
        
        static let showPet = "petSelection.showPet".localized()
        static let trackingAlert = "petSelection.trackingAlert".localized()
    }
    
    // MARK: - Purchases
    
    class Purchases {
        
        static let buy = "purchases.buy".localized()
        static let buyFor = "purchases.buyFor".localized()
        static let purchasing = "purchases.purchasing".localized()
        static let purchased = "purchases.purchased".localized()
    }
}

// MARK: - Pets

extension Pet {
    
    var name: String { "pet.name.\(id)".localized() }
    var about: String { "pet.about.\(id)".localized() }
}

// MARK: - App Pages

extension AppPage {
    
    var title: String { "page.title.\(rawValue)".localized() }
}

// MARK: - Utils

extension String {

    func localized() -> String {
        NSLocalizedString(self, bundle: .main, comment: self)
    }
}

