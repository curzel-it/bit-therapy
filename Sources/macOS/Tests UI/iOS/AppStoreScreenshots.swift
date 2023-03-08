import XCTest

final class AppStoreScreenshots: XCTestCase {
    func testTakeScreenshot() {
        let app = XCUIApplication()
        app.launchArguments.append("background=BackgroundMountainDay")
        
        // Set the device model to iPhone 12 Pro
        let device = XCUIDevice.shared
        device.orientation = .portrait

        app.launch()

        // Take a screenshot of the app's main screen
        let screenshot = XCUIScreen.main.screenshot()

        // Get the PNG representation of the screenshot
        let pngData = screenshot.pngRepresentation

        // Save the screenshot to the file path
        let filePath = "/Users/curzel/Desktop/MainScreen.png"
        
        do {
            try pngData.write(to: URL(fileURLWithPath: filePath), options: .atomic)
        } catch {
            XCTFail("Failed to write screenshot data to file: \(error)")
        }
    }
}
