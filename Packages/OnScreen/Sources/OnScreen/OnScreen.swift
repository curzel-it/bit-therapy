import AppState
import Combine
import DesktopKit
import Pets
import Schwifty
import Squanch
import SwiftUI

public struct OnScreen {
    
    private static var viewModel: ViewModel?
    private static var habitatWindows: OnScreenWindows?
    
    public static func show() {
        hide()
        printDebug("OnScreen", "Starting...")
        self.viewModel = ViewModel()
        self.habitatWindows = OnScreenWindows(for: viewModel)
    }
    
    public static func hide(animated: Bool = true) {
        printDebug("OnScreen", "Hiding everything...")
        viewModel?.kill(animated: animated)
        viewModel = nil
        habitatWindows?.kill()
        habitatWindows = nil
    }
}

class OnScreenWindows: HabitatWindows {
    
    override func windowWillClose(_ notification: Notification) {
        super.windowWillClose(notification)
        if isAlive && windows.count == 0 {
            printDebug("OnScreen", "No more windows, terminating")
            kill()
            OnScreen.hide(animated: false)
        }
    }
}
