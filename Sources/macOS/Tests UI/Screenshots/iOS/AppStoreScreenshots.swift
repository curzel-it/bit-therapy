import XCTest

final class AppStoreScreenshots: XCTestCase {
    override class func tearDown() {
        super.tearDown()
        let path = ScreenshotsHelper.screenshotsRoot().absoluteString
        print("You can find screenshots at: \(path)")
        print("open \(path.replacingOccurrences(of: "file:///", with: "/"))")
    }
    
    func testTakeHomeScreenshots() {
        for lang in Language.allCases {
            for theme in Theme.allCases {
                let manager = ScreenshotsHelper(language: lang, theme: theme, orientation: .portrait)
                let app = manager.launch()
                navigateToHome(in: app)
                let screenshot = manager.screenshot(for: "home")
                add(screenshot)
            }
        }
    }
    
    func testTakeScreensaverScreenshots() {
        for lang in Language.allCases {
            for theme in Theme.allCases {
                for orientation in Orientation.allCases {
                    let manager = ScreenshotsHelper(language: lang, theme: theme, orientation: orientation)
                    let app = manager.launch()
                    navigateToScreensaver(in: app)
                    Thread.sleep(forTimeInterval: 1)
                    let screenshot = manager.screenshot(for: "screensaver")
                    add(screenshot)
                }
            }
        }
    }
    
    private func navigateToHome(in app: XCUIApplication) {
        let closeOnboarding = app.buttons["close_onboarding"]
        if closeOnboarding.exists {
            closeOnboarding.tap()
        }
    }
    
    private func navigateToScreensaver(in app: XCUIApplication) {
        navigateToHome(in: app)
        app.staticTexts["screensaver"].tap()
    }
}

