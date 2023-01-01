import SwiftUI

enum AppPage: String, CaseIterable {
    case about
    case home
    case none
    case news
    case settings
}

extension AppPage: CustomStringConvertible {
    var description: String {
        switch self {
        case .about: return Lang.Page.about
        case .home: return Lang.Page.home
        case .none: return ""
        case .settings: return Lang.Page.settings
        case .news: return Lang.Page.news
        }
    }
}

extension AppPage {
    var icon: String {
        switch self {
        case .about, .none: return "info.square.fill"
        case .home: return "circle.grid.3x3.fill"
        case .settings: return "gearshape.fill"
        case .news: return "message.fill"
        }
    }
}
