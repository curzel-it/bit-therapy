//
// Pet Therapy.
//

import Foundation
import Pets
import Squanch

// MARK: - Setup

public struct Tracking {
    
    public static var isEnabled = false
    
    public static func setup(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}

// MARK: - Events

extension Tracking {
    
    public static func didLaunchApp(
        gravityEnabled: Bool,
        petSize: CGFloat,
        launchAtLogin: Bool,
        selectedPet: String
    ) {
        // ...
    }
    
    public static func didRestorePurchases() {
        // ...
    }
    
    public static func didSelect(_ pet: Pet) {
        // ...
    }
    
    public static func didEnterDetails(of pet: Pet) {
        // ...
    }
    
    public static func didBuy(_ pet: Pet, success: Bool) {
        // ...
    }
}
