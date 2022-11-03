import Foundation
import Schwifty

// As you have probably guessed, a piece of code is missing here.
// Removing the code was the easiest way to hide both cheat codes and their effect...
// I am a lazy guy, please understand :D
// You can just `return false` in `enableCheat` to make the app compile for personal use.
struct Cheats {
    static func enableCheats() {
        enabledCodes().forEach { enableCheat(code: $0, save: false) }
    }
    
    @discardableResult
    static func enableCheat(code: String, save: Bool = true) -> Bool {
        // Just return false if building from source.
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

