import AppState
import Foundation
import Squanch

// I wanted to distribute pets for free to supporters, and this is the easiest way.
// Cheat codes are easy to guess, feel free to use them without shame...
// Just remember you can support me on Patreon if you want! haha
// https://www.patreon.com/urinamara
// https://discord.gg/MCdEgXKSH5
struct Cheats {
    static func enableCheats() {
        enabledCodes().forEach { enableCheat(code: $0, save: false) }
    }
    
    @discardableResult
    static func enableCheat(code: String, save: Bool = true) -> Bool {
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

