import AppState
import Combine
import DesktopKit
import Pets
import Schwifty
import Squanch
import SwiftUI

public struct OnScreen {
    
    private static var viewModel: ViewModel?
    private static var worldWindows: OnScreenWindows?
    
    public static func show() {
        hide()
        printDebug("OnScreen", "Starting...")
        self.viewModel = ViewModel()
        self.worldWindows = OnScreenWindows(for: viewModel)
    }
    
    public static func hide() {
        printDebug("OnScreen", "Hiding everything...")
        viewModel?.kill()
        viewModel = nil
        worldWindows?.kill()
        worldWindows = nil
    }
}

class OnScreenWindows: WorldWindows {
    
    override func windowWillClose(_ notification: Notification) {
        super.windowWillClose(notification)
        if isAlive && windows.count == 0 {
            printDebug("OnScreen", "No more windows, terminating")
            kill()
            OnScreen.hide()
        }
    }
}
