//
// Pet Therapy.
//

import SwiftUI

@main
struct MyApp: App {
    
    init() {
        // ...
    }
    
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            let mainScreen = NSScreen.main ?? NSScreen.screens.first
            let screenBounds = mainScreen?.frame ?? .zero
            
            MainView(size: screenBounds.size)
                .onWindow { window in
                    MainWindowDelegate.setup(for: window)
                }
#else
            MainView(size: UIScreen.main.bounds.size)
#endif
        }
    }
}
