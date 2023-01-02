import AppKit
import Foundation
import OnScreen
import Schwifty

let kUnlockAllPets = "AllYourBaseAreBelongToUs"
let kUfoAbduction = "DamnAliens!"
let kSet = "Set!"

enum Cheat {
    case ufoAbduction
    case stringSet(key: String, value: String)
    case doubleSet(key: String, value: Double)
    case boolSet(key: String, value: Bool)
    
    var isSingleUse: Bool { true }
    
    static func from(code: String) -> Cheat? {
        switch code {
        case kUfoAbduction: return .ufoAbduction
        default: return keySet(from: code)
        }
    }
    
    private static func keySet(from code: String) -> Cheat? {
        guard code.starts(with: kSet) else { return nil }
        let tokens = code
            .replacingOccurrences(of: kSet, with: "")
            .components(separatedBy: "=")
        guard tokens.count == 2 else { return nil }
        
        if let value = Double(tokens[1]) {
            return .doubleSet(key: tokens[0], value: value)
        }
        if let value = Bool(tokens[1]) {
            return .boolSet(key: tokens[0], value: value)
        }
        return .stringSet(key: tokens[0], value: tokens[1])
    }
    
    func code() -> String {
        switch self {
        case .ufoAbduction: return kUfoAbduction
        case .stringSet(let key, let value): return "\(kSet)\(key)=\(value)"
        case .doubleSet(let key, let value): return "\(kSet)\(key)=\(value)"
        case .boolSet(let key, let value): return "\(kSet)\(key)=\(value)"
        }
    }
    
    func enable() {
        switch self {
        case .stringSet(let key, let value): set(value: value, forKey: key)
        case .doubleSet(let key, let value): set(value: value, forKey: key)
        case .boolSet(let key, let value): set(value: value, forKey: key)
        case .ufoAbduction: triggerUfoAbduction()
        }
    }
    
    private func triggerUfoAbduction() {
        Logger.log("Cheats", "Triggering UFO Abduction")
        OnScreenCoordinator.triggerUfoAbduction()
    }
    
    private func set(value: Any, forKey key: String) {
        Logger.log("Cheats", "Setting '\(key)' to '\(value)'")
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
        reboot()
    }
    
    private func reboot() {
        Logger.log("Cheats", "Relaunching app...")
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        config.createsNewApplicationInstance = true
        NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: config)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApp.terminate(self)
        }
    }
}
