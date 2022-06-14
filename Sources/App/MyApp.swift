//
// Pet Therapy.
//

import SwiftUI
import Schwifty

@main
struct MyApp: App {
    
    init() {
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
