//
// Pet Therapy.
//

import Squanch
import LaunchAtLogin

// MARK: - Events

struct Tracking {
    
    static func didLaunchApp() {
        // ...
    }
    
    static func didRestorePurchases() {
        // ...
    }
    
    static func didSelect(_ pet: Pet) {
        // ...
    }
    
    static func didEnterDetails(of pet: Pet) {
        // ...
    }
    
    static func didBuy(_ pet: Pet, success: Bool) {
        // ...
    }
}
