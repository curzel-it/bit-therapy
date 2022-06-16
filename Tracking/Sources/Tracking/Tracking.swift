//
// Pet Therapy.
//

import Lang
import Pets
import Squanch
import SwiftUI

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
    
    public static func didEnterDetails(of pet: Pet, price: Double, purchased: Bool) {
        // ...
    }
    
    public static func purchased(pet: Pet, price: Double, success: Bool) {
        // ...
    }
}
