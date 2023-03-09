import Foundation

protocol LaunchAtLoginUseCase {
    var isAvailable: Bool { get }
    var isEnabled: Bool { get }
    func disable()
    func enable()
}

#if os(macOS)
import LaunchAtLogin

class LaunchAtLoginUseCaseImpl: LaunchAtLoginUseCase {
    var isAvailable: Bool { true }
    var isEnabled: Bool { LaunchAtLogin.isEnabled }
    func disable() { LaunchAtLogin.isEnabled = false }
    func enable() { LaunchAtLogin.isEnabled = true }
}
#else
class LaunchAtLoginUseCaseImpl: LaunchAtLoginUseCase {
    var isAvailable: Bool { false }
    var isEnabled: Bool { false }
    func disable() {}
    func enable() {}
}
#endif
