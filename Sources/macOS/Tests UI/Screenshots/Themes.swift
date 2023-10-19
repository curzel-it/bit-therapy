import XCTest

enum Theme: String, CaseIterable {
    case light
    case dark
    
    var background: String {
        switch self {
        case .light: return "BackgroundMountainDay"
        case .dark: return "BackgroundMountainNight"
        }
    }
}
