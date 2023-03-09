import Schwifty
import XCTest

class ScreenshotsHelper {
    private let lang: Language
    private let orientation: Orientation
    private let theme: Theme
    
    init(language: Language, theme: Theme, orientation: Orientation) {
        self.lang = language
        self.theme = theme
        self.orientation = orientation
    }
    
    @discardableResult
    func launch() -> XCUIApplication {
        setDeviceOrientation()
        let app = XCUIApplication()
        setLanguage(in: app)
        app.launchArguments.append("background=\(theme.background)")
        app.launchArguments.append("pets=cat_blue,cat_grumpy,snail,mushroom_amanita")
        app.launchArguments.append("petSize=\(petSize())")
        app.launch()
        return app
    }
    
    func screenshot(for name: String) -> XCTAttachment {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = fileName(for: name)
        attachment.lifetime = .keepAlways
        save(screenshot, as: name)
        return attachment
    }
    
    static func screenshotsRoot() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("Screenshots", isDirectory: true)
    }
    
    private func save(_ screenshot: XCUIScreenshot, as name: String) {
        let folder = screenshotsDir()
        let data = screenshot.pngRepresentation
        let fileURL = folder.appendingPathComponent("\(theme)_\(orientation)_\(name).png")
        do {
            try data.write(to: fileURL, options: .atomic)
            print("Saved screenshot at: \(fileURL.absoluteString)")
        } catch {
            XCTFail("Failed to write screenshot to file: \(error)")
        }
    }
    
    private func screenshotsDir() -> URL {
        let folder = ScreenshotsHelper
            .screenshotsRoot()
            .appendingPathComponent(lang.language, isDirectory: true)
            .appendingPathComponent(deviceName(), isDirectory: true)
        
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        } catch {
            XCTFail("Failed to create screenshots folder: \(error)")
        }
        return folder
    }
    
    private func setDeviceOrientation() {
#if !os(macOS)
        let device = XCUIDevice.shared
        device.orientation = orientation.uiOrientation
#endif
    }
    
    private func setLanguage(in app: XCUIApplication) {
        app.launchArguments += ["-AppleLanguages", "(\(lang.language))"]
        app.launchArguments += ["-AppleLocale", lang.locale]
    }
    
    private func fileName(for name: String) -> String? {
        "\(name)_\(fileNameSuffix()).png"
    }
    
    private func fileNameSuffix() -> String {
        return [
            lang.rawValue,
            deviceName(),
            theme.rawValue,
            orientation.rawValue
        ].joined(separator: "_")
    }
    
    private func deviceName() -> String {
#if os(macOS)
        return "macOS"
#else
        return UIDevice.current.name.replacingOccurrences(of: " ", with: "_")
#endif
    }
    
    private func petSize() -> CGFloat {
        DeviceRequirement.iPhone.isSatisfied ? 75 : 100
    }
}
