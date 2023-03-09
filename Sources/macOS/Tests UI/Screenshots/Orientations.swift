import XCTest

enum Orientation: String, CaseIterable {
    case portrait
    
#if !os(macOS)
    case landscape
    
    var uiOrientation: UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscape: return .landscapeLeft
        }
    }
#endif
}
