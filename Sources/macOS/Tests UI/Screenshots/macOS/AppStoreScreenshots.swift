import Schwifty
import XCTest

/// Will take screenshots for AppStore page.
/// Screenshots path can be find in console log at the end of the process.
/// Use `Scripts/macos_screnshots_resize.py` to resize screenshots if needed (ie. if using a mb pro with notch).
///   `python3 macos_screnshots_resize.py <folder from console log>
/// This will create cropped and resized screenshots in Scripts/generated/screenshots
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
                Thread.sleep(forTimeInterval: 5)
                let screenshot = manager.screenshot(for: "home")
                add(screenshot)
            }
        }
    }
    
    func testTakeSettingsScreenshots() {
        for lang in Language.allCases {
            for theme in Theme.allCases {
                let manager = ScreenshotsHelper(language: lang, theme: theme, orientation: .portrait)
                let app = manager.launch()
                navigateToSettings(in: app)
                Thread.sleep(forTimeInterval: 5)
                let screenshot = manager.screenshot(for: "settings")
                add(screenshot)
            }
        }
    }
    
    private func navigateToHome(in app: XCUIApplication) {
        let closeOnboarding = app.buttons["close_onboarding"]
        if closeOnboarding.exists {
            closeOnboarding.tap()
        }
    }
    
    private func navigateToSettings(in app: XCUIApplication) {
        navigateToHome(in: app)
        app.staticTexts["settings"].tap()
    }
}

