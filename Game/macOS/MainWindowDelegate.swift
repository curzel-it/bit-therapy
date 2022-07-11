//
// Pet Therapy.
//

import GameState
import Biosphere
import DesignSystem
import SwiftUI
import Schwifty

class MainWindowDelegate: NSObject, NSWindowDelegate {
    
    fileprivate static var instance: MainWindowDelegate?
    
    fileprivate weak var window: NSWindow?
    
    static func setup(for window: NSWindow) {
        let delegate = MainWindowDelegate()
        delegate.window = window
        window.delegate = delegate
        window.toggleFullScreen(window)
        window.styleMask.remove(.resizable)
        MainWindowDelegate.instance = delegate
        GameState.global.mainWindowSize = window.frame.size
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        GameState.global.mainWindowSize = frameSize
        return frameSize
    }
    
    func windowWillClose(_ notification: Notification) {
        Task { @MainActor in
            GameState.global.mainWindowFocused = false
            MainWindowDelegate.instance = nil
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        Task { @MainActor in
            GameState.global.mainWindowFocused = true
        }
    }
    
    func windowDidResignMain(_ notification: Notification) {
        Task { @MainActor in
            GameState.global.mainWindowFocused = false
        }
    }
}
