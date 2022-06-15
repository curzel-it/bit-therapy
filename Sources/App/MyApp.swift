//
// Pet Therapy.
//

import InAppPurchases
import SwiftUI
import Schwifty
import Tracking

@main
struct MyApp: App {
    
    init() {
        Tracking.setup(isEnabled: AppState.global.trackingEnabled)
        PricingService.global.setup()
        Task { @MainActor in
            OnScreenWindow.show(onlyIfNeeded: true)
            StatusBarItems.main.setup()
        }
    }
    
    var body: some Scene {
        MainWindow()
    }
}
