import AppState
import Foundation
import InAppPurchases
#if os(macOS)
import OnScreen
#endif
import Squanch

// I wanted to distribute pets for free to supporters, and this is the easiest way.
// Cheat codes are easy to guess, feel free to use them without shame...
// Just remember you can support me on Patreon if you want! haha
// https://www.patreon.com/urinamara
// https://discord.gg/MCdEgXKSH5
struct Cheats {
    static func enableCheats() {
        enabledCheats().forEach { $0.enable() }
    }
    
    static func enableCheat(code: String) -> Cheat? {
        guard let key = availableCheats[code] as? String else { return nil }
        guard let cheat = Cheat(rawValue: key) else { return nil }
        add(activeCode: cheat)
        return cheat
    }
    
    private static func enabledCheats() -> [Cheat] {
        enabledCodes().compactMap { enableCheat(code: $0) }
    }
    
    static func clear() {
        UserDefaults.standard.set(nil, forKey: kEnabledCheats)
    }
    
    private static func enabledCodes() -> [String] {
        UserDefaults.standard.stringArray(forKey: kEnabledCheats) ?? []
    }
    
    private static func add(activeCode cheat: Cheat) {
        guard !cheat.isSingleUse else { return }
        UserDefaults.standard.set(
            enabledCodes() + [cheat.rawValue],
            forKey: kEnabledCheats
        )
    }
    
    private static var availableCheats: NSDictionary = {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let props = try? NSDictionary(contentsOf: url, error: ()),
            let cheats = props["Cheats"] as? NSDictionary
        else { return NSDictionary() }
        return cheats
    }()
}

private let kEnabledCheats = "kEnabledCheats"

enum Cheat: String {
    case unlockAllPets
    case ufoAbduction
    
    func enable() {
        switch self {
        case .ufoAbduction:
#if os(macOS)
            printDebug("Cheats", "Triggering UFO Abduction")
            OnScreen.triggerUfoAbduction()
#else
            printDebug("Cheats", "Triggering UFO Abduction not supported on iOS")
#endif
            
        case .unlockAllPets:
            printDebug("Cheats", "Unlocked all pets")
            PricingService.global.isAvailable = false
        }
    }
    
    var isSingleUse: Bool {
        switch self {
        case .ufoAbduction: return true
        default: return false
        }
    }
}
