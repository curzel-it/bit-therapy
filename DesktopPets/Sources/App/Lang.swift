import Foundation
import Pets

public enum Lang {
    
    // MARK: - Generic
    
    public static let cancel = "cancel".localized()
    public static let select = "select".localized()
    public static let remove = "remove".localized()
    public static let reset = "reset".localized()
    public static let enable = "enable".localized()
    public static let disable = "disable".localized()
    public static let loading = "loading".localized()
    public static let done = "done".localized()
    public static let somethingWentWrong = "somethingWentWrong".localized()
    
    // MARK: - Pages
    
    public enum Page {
        public static let home = "page.title.home".localized()
        public static let settings = "page.title.settings".localized()
        public static let about = "page.title.about".localized()
    }
    
    // MARK: - Menu
    
    public enum Menu {
        public static func item(_ key: String) -> String { "menu.item.\(key)".localized() }
    }
    
    // MARK: - Cheats
    
    public enum Cheats {
        public static let title = "cheats.title".localized()
        public static let placeholder = "cheats.placeholder".localized()
        public static let enable = "cheats.enable".localized()
        public static let invalidCode = "cheats.invalidCode".localized()
        public static let validCode = "cheats.validCode".localized()
    }
    
    // MARK: - Survey
    
    public enum Survey {
        public static let feedbackViaSurvey = "survey.feedbackViaSurvey".localized()
        public static let requestPetViaSurvey = "survey.requestPetViaSurvey".localized()
        public static let takeSurvey = "survey.takeSurvey".localized()        
        public static var url: URL? { URL(string: urlString) }
        private static let urlString = "survey.url".localized()
    }
    
    // MARK: - Settings
    
    public enum Settings {
        public static let gravity = "settings.gravity".localized()
        public static let size = "settings.size".localized()
        public static let launchAtLogin = "settings.launchAtLogin".localized()
        public static let statusBarIconEnabled = "settings.statusBarIconEnabled".localized()
        public static let anonymousTracking = "settings.anonymousTracking".localized()
        public static let anonymousTrackingExplainedTitle = "settings.anonymousTracking.title".localized()
        public static let anonymousTrackingExplained = "settings.anonymousTracking.message".localized()
        public static let speed = "settings.speed".localized()
        public static let restorePurchases = "settings.restorePurchases".localized()
        public static let desktopInteractions = "settings.desktopInteractions.title".localized()
        public static let desktopInteractionsMessage = "settings.desktopInteractions.message".localized()
    }
    
    // MARK: - About
    
    public enum About {
        public static let leaveReviewMessage = "about.leaveReviewMessage".localized()
        public static let leaveReview = "about.leaveReview".localized()
        public static let joinRedditMessage = "about.joinRedditMessage".localized()
        public static let joinReddit = "about.joinReddit".localized()
        public static let mailMessage = "about.mailMessage".localized()
        public static let mail = "about.mail".localized()
        public static let privacyPolicy = "about.privacyPolicy".localized()
    }
    
    // MARK: - Pet Selection
    
    public enum PetSelection {
        public static let joinDiscord = "petSelection.joinDiscord".localized()
        public static let fixOnScreenPets = "petSelection.fixOnScreenPets".localized()
        public static let addPet = "petSelection.addPet".localized()
        public static let yourPets = "petSelection.yourPets".localized()
        public static let morePets = "petSelection.morePets".localized()
    }
    
    // MARK: - Purchases
    
    public enum Purchases {
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

private extension String {
    func localized(in bundle: Bundle = .main) -> String {
        NSLocalizedString(self, bundle: bundle, comment: self)
    }
}

