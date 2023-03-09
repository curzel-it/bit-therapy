import SwiftUI

enum AppPage: String, CaseIterable {
    case about
    case contributors
    case none
    case petSelection
    case screensaver
    case settings
}

extension AppPage: TabBarItem {
    var accessibilityIdentifier: String { rawValue }
    
    var icon: String {
        switch self {
        case .about: return "info.circle"
        case .contributors: return "person.2"
        case .petSelection: return "pawprint"
        case .screensaver: return "gamecontroller"
        case .settings: return "gearshape"
        case .none: return "questionmark.diamond"
        }
    }
    
    var iconSelected: String { "\(icon).fill" }
    
    var title: String { description }
}
