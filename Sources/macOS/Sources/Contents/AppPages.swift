import SwiftUI

enum AppPage: String, CaseIterable {
    case about
    case contributors
    case none
    case petSelection
    case screensaver
    case settings
}

extension AppPage: TabSelectable {}

extension AppPage: TabBarItem {
    var icon: String {
        switch self {
        case .about: return "info.circle"
        case .contributors: return "info.circle"
        case .petSelection: return "pawprint"
        case .screensaver: return "binoculars"
        case .settings: return "gearshape"
        case .none: return "questionmark.diamond"
        }
    }
    
    var iconSelected: String { "\(icon).fill" }
    
    var title: String { description }
}
