import Foundation
import Schwifty

struct Cheats {
    static func enableCheats() {
        enabledCodes().forEach { enableCheat(code: $0, save: false) }
    }

    @discardableResult
    static func enableCheat(code: String, save: Bool = true) -> Bool {
        // Comment out the body of this function and return false if building from source.
        guard let cheat = Cheat.from(code: code) else { return false }
        cheat.enable()
        if save && !cheat.isSingleUse {
            register(activatedCode: code)
        }
        return true
    }

    static func clear() {
        UserDefaults.standard.set(nil, forKey: kEnabledCheats)
    }

    private static func enabledCodes() -> [String] {
        UserDefaults.standard.stringArray(forKey: kEnabledCheats) ?? []
    }

    private static func register(activatedCode code: String) {
        UserDefaults.standard.set(enabledCodes() + [code], forKey: kEnabledCheats)
    }
}

private let kEnabledCheats = "kEnabledCheats"
