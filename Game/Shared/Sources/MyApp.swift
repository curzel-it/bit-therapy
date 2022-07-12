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
            
            MainView(size: screenBounds.size, safeAreaInsets: .init())
                .onWindow { window in
                    MainWindowDelegate.setup(for: window)
                }
#else
            MainView(
                size: UIScreen.main.bounds.size,
                safeAreaInsets: EdgeInsets(
                    top: 50, // TODO: Use actual safe area insets
                    leading: 0,
                    bottom: 50,
                    trailing: 0
                )
            )
#endif
        }
    }
}
