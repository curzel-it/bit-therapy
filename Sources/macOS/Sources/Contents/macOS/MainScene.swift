import Combine
import Schwifty
import SwiftUI

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            MacContentView()
        }
    }
    
    static func show() {
        if let window = AppWindowManager.shared.current {
            window.makeKey()
            window.makeMain()
        } else {
            showMainWindow()
        }
        trackAppLaunched()
    }

    private static func showMainWindow() {
        let window = AppWindowManager.shared.build()
        AppWindowManager.shared.current = window
        window.show()
    }

    private static func trackAppLaunched() {
        @Inject var appState: AppState
        @Inject var launchAtLogin: LaunchAtLoginUseCase
        
        Tracking.didLaunchApp(
            gravityEnabled: appState.gravityEnabled,
            petSize: appState.petSize,
            launchAtLogin: launchAtLogin.isEnabled,
            selectedSpecies: appState.selectedSpecies
        )
    }
}

