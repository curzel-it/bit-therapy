import Schwifty
import SwiftUI

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            MacContentView()
        }
    }
}

private struct MacContentView: View {
    @StateObject var appState = AppState.global
    
    fileprivate static weak var currentWindow: NSWindow?
    fileprivate static let minSize = CGSize(square: 700)
    
    var body: some View {
        ContentView()
            .frame(minWidth: MacContentView.minSize.width)
            .frame(minHeight: MacContentView.minSize.height)
            .onWindow { MacContentView.currentWindow = $0 }
            .environmentObject(appState)
    }
}

extension MainScene {
    static func show() {
        if let window = MacContentView.currentWindow {
            window.makeKey()
            window.makeMain()
        } else {
            showMainWindow()
        }
        trackAppLaunched()
    }

    private static func showMainWindow() {
        let view = NSHostingView(rootView: MacContentView())
        let window = NSWindow(
            contentRect: MainScene.defaultWindowRect(),
            styleMask: [.resizable, .closable, .titled, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        if let preferredAppearance = AppState.global.preferredAppearance() {
            window.appearance = preferredAppearance
        }
        window.minSize = MacContentView.minSize
        window.title = Lang.appName
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        MacContentView.currentWindow = window
        window.show()
    }
    
    private static func defaultWindowRect() -> CGRect {
        let center = Screen.main?.frame.center ?? CGPoint(x: 400, y: 200)
        let size = MacContentView.minSize
        return CGRect(origin: center, size: size)
            .offset(x: -size.width/2)
            .offset(y: -size.height/2)
    }

    private static func trackAppLaunched() {
        @Inject var launchAtLogin: LaunchAtLoginUseCase
        let appState = AppState.global
        Tracking.didLaunchApp(
            gravityEnabled: appState.gravityEnabled,
            petSize: appState.petSize,
            launchAtLogin: launchAtLogin.isEnabled,
            selectedSpecies: appState.selectedSpecies
        )
    }
}

private extension AppState {
    func preferredAppearance() -> NSAppearance? {
        let backgroundName = background.lowercased()
        if backgroundName.contains("day") { return NSAppearance(named: .aqua) }
        if backgroundName.contains("night") { return NSAppearance(named: .darkAqua) }
        return nil
    }
}

// TODO: Observe change in background to change window appearance
