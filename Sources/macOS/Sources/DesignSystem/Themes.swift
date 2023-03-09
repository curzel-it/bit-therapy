import Combine
import SwiftUI

enum Theme: String {
    case light
    case dark
    case system
}

protocol ThemeUseCase {
    func theme() -> AnyPublisher<Theme, Never>
}

class ThemeUseCaseImpl: ThemeUseCase {
    @Inject private var appConfig: AppConfig
    
    func theme() -> AnyPublisher<Theme, Never> {
        appConfig.$background
            .map { [weak self] in self?.theme(fromBackgroundName: $0) ?? .system }
            .eraseToAnyPublisher()
    }
    
    private func theme(fromBackgroundName backgroundName: String) -> Theme {
        let name = backgroundName.lowercased()
        switch true {
        case name.contains("day"): return .light
        case name.contains("night"): return .dark
        default: return .system
        }
    }
}

extension Theme {
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

#if os(macOS)
extension Theme {
    var appearance: NSAppearance? {
        switch self {
        case .light: return NSAppearance(named: .aqua)
        case .dark: return NSAppearance(named: .darkAqua)
        case .system: return nil
        }
    }
}
#endif
