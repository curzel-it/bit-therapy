import Foundation
import Pets
import Schwifty
import Yage

enum Lang {
    static let appName = "appName".localized()
    static let cancel = "cancel".localized()
    static let disable = "disable".localized()
    static let done = "done".localized()
    static let enable = "enable".localized()
    static let loading = "loading".localized()
    static let remove = "remove".localized()
    static let reset = "reset".localized()
    static let screen = "screen".localized()
    static let select = "select".localized()
    static let somethingWentWrong = "somethingWentWrong".localized()

    enum About {
        static let joinReddit = "about.joinReddit".localized()
        static let joinRedditMessage = "about.joinRedditMessage".localized()
        static let leaveReview = "about.leaveReview".localized()
        static let leaveReviewMessage = "about.leaveReviewMessage".localized()
        static let mail = "about.mail".localized()
        static let mailMessage = "about.mailMessage".localized()
        static let privacyPolicy = "about.privacyPolicy".localized()
    }
    
    enum CustomPets {
        static let export = "customPets.export".localized()
    }
    
    enum Cheats {
        static let enable = "cheats.enable".localized()
        static let invalidCode = "cheats.invalidCode".localized()
        static let placeholder = "cheats.placeholder".localized()
        static let title = "cheats.title".localized()
        static let validCode = "cheats.validCode".localized()
    }

    enum Donations {
        static let linkTitle = "donations.linkTitle".localized()
        static let message = "donations.message".localized()
        static let title = "donations.title".localized()
    }

    enum Page {
        static let about = "page.about".localized()
        static let help = "page.help".localized()
        static let home = "page.home".localized()
        static let news = "page.news".localized()
        static let settings = "page.settings".localized()
    }

    enum PetSelection {
        static let addPet = "petSelection.addPet".localized()
        static let fixOnScreenPets = "petSelection.fixOnScreenPets".localized()
        static let joinDiscord = "petSelection.joinDiscord".localized()
        static let morePets = "petSelection.morePets".localized()
        static let petSelection = "petSelection.petSelection".localized()
        static let yourPets = "petSelection.yourPets".localized()
    }

    enum Settings {
        static let anonymousTracking = "settings.anonymousTracking".localized()
        static let anonymousTrackingMessage = "settings.anonymousTrackingMessage".localized()
        static let anonymousTrackingTitle = "settings.anonymousTrackingTitle".localized()
        static let desktopInteractionsMessage = "settings.desktopInteractionsMessage".localized()
        static let desktopInteractionsTitle = "settings.desktopInteractionsTitle".localized()
        static let enabledDisplays = "settings.enabledDisplays".localized()
        static let gravity = "settings.gravity".localized()
        static let launchAtLogin = "settings.launchAtLogin".localized()
        static let size = "settings.size".localized()
        static let speed = "settings.speed".localized()
        static let statusBarIconEnabled = "settings.statusBarIconEnabled".localized()
    }

    enum Urls {
        static let appStore = "urls.appStore".localized()
        static let discord = "urls.discord".localized()
        static let donations = "urls.donations".localized()
        static let github = "urls.github".localized()
        static let mailto = "urls.mailto".localized()
        static let privacy = "urls.privacy".localized()
        static let reddit = "urls.reddit".localized()
        static let twitter = "urls.twitter".localized()
    }
}

extension Lang {
    static func name(forMenuItem item: String) -> String {
        "menu.\(item)".localized()
    }
}

extension Species {
    var name: String { "species.name.\(id)".localized() }
    var about: String { "species.about.\(id)".localized() }
}

private extension String {
    func localized(in bundle: Bundle = .main) -> String {
        NSLocalizedString(self, bundle: bundle, comment: self)
    }
}
