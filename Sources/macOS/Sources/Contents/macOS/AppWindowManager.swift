import Combine
import Schwifty
import SwiftUI

class AppWindowManager {
    static let shared = AppWindowManager()
    
    weak var current: NSWindow?
    
    @Inject private var theme: ThemeUseCase
    private var appearance: NSAppearance?
    private var disposables = Set<AnyCancellable>()
    
    init() {
        bindAppearance()
    }
    
    func build() -> NSWindow {
        let window = AppWindow(
            contentRect: initialContentRect(),
            styleMask: [.resizable, .closable, .titled, .miniaturizable, .fullScreen, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        loadContents(into: window.contentView)
        customize(window)
        return window
    }
    
    func customize(_ window: NSWindow) {
        window.setFrame(initialContentRect(), display: true)
        window.minSize = MacContentView.minSize
        window.title = Lang.appName
        window.appearance = appearance
        window.collectionBehavior = [.fullScreenPrimary, .fullScreenAllowsTiling]        
    }
    
    private func loadContents(into contentView: NSView?) {
        let view = NSHostingView(rootView: MacContentView())
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(view)
        view.constrainToFillParent()
    }
    
    private func bindAppearance() {
        theme.theme()
            .sink { [weak self] theme in
                guard let self else { return }
                self.appearance = theme.appearance
                self.current?.appearance = theme.appearance
            }
            .store(in: &disposables)
    }
    
    private func initialContentRect() -> CGRect {
        let center = Screen.main?.frame.center ?? CGPoint(x: 400, y: 200)
        let size = MacContentView.minSize
        return CGRect(origin: center, size: size)
            .offset(x: -size.width/2)
            .offset(y: -size.height/2)
    }
}

private class AppWindow: NSWindow {
    override func close() {
        super.close()
        AppWindowManager.shared.current = nil
    }
}
