import Foundation
import Pets
import Schwifty
import Yage

enum Lang {
    static let appName = "Desktop Pets"
    static let cancel = "cancel".localized()
    static let select = "select".localized()
    static let remove = "remove".localized()
    static let reset = "reset".localized()
    static let screen = "screen".localized()
    static let enable = "enable".localized()
    static let disable = "disable".localized()
    static let loading = "loading".localized()
    static let done = "done".localized()
    static let somethingWentWrong = "somethingWentWrong".localized()

    enum Page {
        static let about = "page.title.about".localized()
        static let game = "page.title.game".localized()
        static let home = "page.title.home".localized()
        static let settings = "page.title.settings".localized()
        static let news = "page.title.news".localized()
    }

    enum Menu {
        static func item(_ key: String) -> String { "menu.item.\(key)".localized() }
    }

    enum Cheats {
        static let title = "cheats.title".localized()
        static let placeholder = "cheats.placeholder".localized()
        static let enable = "cheats.enable".localized()
        static let invalidCode = "cheats.invalidCode".localized()
        static let validCode = "cheats.validCode".localized()
    }
    
    enum Donations {
        static let title = "donations.title".localized()
        static let message = "donations.message".localized()
        static let link = "donations.link".localized()
        static let linkTitle = "donations.linkTitle".localized()
    }

    enum Settings {
        static let gravity = "settings.gravity".localized()
        static let size = "settings.size".localized()
        static let launchAtLogin = "settings.launchAtLogin".localized()
        static let statusBarIconEnabled = "settings.statusBarIconEnabled".localized()
        static let anonymousTracking = "settings.anonymousTracking".localized()
        static let anonymousTrackingExplainedTitle = "settings.anonymousTracking.title".localized()
        static let anonymousTrackingExplained = "settings.anonymousTracking.message".localized()
        static let speed = "settings.speed".localized()
        static let enabledDisplays = "settings.enabledDisplays".localized()
        static let desktopInteractions = "settings.desktopInteractions.title".localized()
        static let desktopInteractionsMessage = "settings.desktopInteractions.message".localized()
    }
    
    enum About {
        static let leaveReviewMessage = "about.leaveReviewMessage".localized()
        static let leaveReview = "about.leaveReview".localized()
        static let joinRedditMessage = "about.joinRedditMessage".localized()
        static let joinReddit = "about.joinReddit".localized()
        static let mailMessage = "about.mailMessage".localized()
        static let mail = "about.mail".localized()
        static let privacyPolicy = "about.privacyPolicy".localized()
    }

    enum PetSelection {
        static let petSelection = "petSelection.petSelection".localized()
        static let joinDiscord = "petSelection.joinDiscord".localized()
        static let fixOnScreenPets = "petSelection.fixOnScreenPets".localized()
        static let addPet = "petSelection.addPet".localized()
        static let yourPets = "petSelection.yourPets".localized()
        static let morePets = "petSelection.morePets".localized()
    }

    enum Urls {
        static let github = "urls.github".localized()
        static let appStore = "urls.appStore".localized()
        static let twitter = "urls.twitter".localized()
        static let discord = "urls.discord".localized()
        static let reddit = "urls.reddit".localized()
        static let mailto = "urls.mailto".localized()
        static let privacy = "urls.privacy".localized()
    }

    enum Game {
        static let intro = "game.intro".localized()
        static let introClose = "game.intro.close".localized()
        static let introComplete = "game.intro.complete".localized()
        static let desktopApp = "game.desktopApp".localized()
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
