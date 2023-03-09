import XCTest

final class AppStoreScreenshots: XCTestCase {
    func testTakeHomeScreenshots() {
        for lang in Language.allCases {
            for theme in Theme.allCases {
                let manager = ScreenshotsHelper(language: lang, theme: theme, orientation: .portrait)
                let app = manager.launch()
                navigateToHome(in: app)
                manager.screenshot(for: "home")
            }
        }
    }
    
    func testTakeScreensaverScreenshots() {
        for theme in Theme.allCases {
            for orientation in Orientation.allCases {
                let manager = ScreenshotsHelper(language: .english, theme: theme, orientation: orientation)
                let app = manager.launch()
                navigateToScreensaver(in: app)
                Thread.sleep(forTimeInterval: 1)
                manager.screenshot(for: "screensaver")
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

