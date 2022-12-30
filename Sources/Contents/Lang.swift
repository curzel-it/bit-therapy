import Foundation
import Pets
import Schwifty
import Yage

public enum Lang {
    // MARK: - Generic

    public static let cancel = "cancel".localized()
    public static let select = "select".localized()
    public static let remove = "remove".localized()
    public static let reset = "reset".localized()
    public static let screen = "screen".localized()
    public static let enable = "enable".localized()
    public static let disable = "disable".localized()
    public static let loading = "loading".localized()
    public static let done = "done".localized()
    public static let somethingWentWrong = "somethingWentWrong".localized()

    // MARK: - Pages

    public enum Page {
        public static let about = "page.title.about".localized()
        public static let game = "page.title.game".localized()
        public static let home = "page.title.home".localized()
        public static let settings = "page.title.settings".localized()
        public static let news = "page.title.news".localized()
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
    
    // MARK: - Donations
    
    public enum Donations {
        public static let title = "donations.title".localized()
        public static let message = "donations.message".localized()
        public static let link = "donations.link".localized()
        public static let linkTitle = "donations.linkTitle".localized()
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
        public static let enabledDisplays = "settings.enabledDisplays".localized()
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
        public static let petSelection = "petSelection.petSelection".localized()
        public static let joinDiscord = "petSelection.joinDiscord".localized()
        public static let fixOnScreenPets = "petSelection.fixOnScreenPets".localized()
        public static let addPet = "petSelection.addPet".localized()
        public static let yourPets = "petSelection.yourPets".localized()
        public static let morePets = "petSelection.morePets".localized()
    }

    // MARK: - URLs

    public enum Urls {
        public static let github = "urls.github".localized()
        public static let appStore = "urls.appStore".localized()
        public static let twitter = "urls.twitter".localized()
        public static let discord = "urls.discord".localized()
        public static let reddit = "urls.reddit".localized()
        public static let mailto = "urls.mailto".localized()
        public static let privacy = "urls.privacy".localized()
    }

    // MARK: - Game

    public enum Game {
        public static let intro = "game.intro".localized()
        public static let introClose = "game.intro.close".localized()
        public static let introComplete = "game.intro.complete".localized()
        public static let desktopApp = "game.desktopApp".localized()
    }
}

// MARK: - Pets

public extension Species {
    var name: String { "species.name.\(id)".localized() }
    var about: String { "species.about.\(id)".localized() }
}

// MARK: - Utils

private extension String {
    func localized(in bundle: Bundle = .main) -> String {
        NSLocalizedString(self, bundle: bundle, comment: self)
    }
}
