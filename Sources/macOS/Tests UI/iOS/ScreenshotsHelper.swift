import XCTest

class ScreenshotsHelper {
    private let lang: Language
    private let orientation: Orientation
    private let theme: Theme
    
    init(
        language: Language,
        theme: Theme,
        orientation: Orientation
    ) {
        self.lang = language
        self.theme = theme
        self.orientation = orientation
    }
    
    @discardableResult
    func launch() -> XCUIApplication {
        let device = XCUIDevice.shared
        device.orientation = orientation.uiOrientation
        
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(\(lang.language))"]
        app.launchArguments += ["-AppleLocale", lang.locale]
        app.launchArguments.append("background=\(theme.background)")
        app.launchArguments.append("pets=cat,cat_blue,cat_grumpy,mushroom_amanita")
        app.launch()
        return app
    }
    
    func screenshot(for name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let pngData = screenshot.pngRepresentation
        guard let filePath = path(for: name) else {
            XCTFail("Could not build path to save screenshots.")
            return
        }
        do {
            try pngData.write(to: URL(fileURLWithPath: filePath), options: .atomic)
        } catch {
            XCTFail("Failed to write screenshot data to file: \(error)")
        }
    }
    
    private func path(for name: String) -> String? {
        guard let desktop = developerDesktopPath() else { return nil }
        return "\(desktop)/\(name)_\(fileNameSuffix()).png"
    }
    
    private func developerDesktopPath() -> String? {
        let pathComponents = Bundle(for: ScreenshotsHelper.self).bundleURL.pathComponents
        guard pathComponents.count > 3, pathComponents[1] == "Users" else { return nil }
        return "/Users/\(pathComponents[2])/Desktop"
        
    }
    
    private func fileNameSuffix() -> String {
        return [
            lang.rawValue,
            UIDevice.current.name.replacingOccurrences(of: " ", with: "_"),
            theme.rawValue,
            orientation.rawValue
        ].joined(separator: "_")
    }
}

enum Language: String, CaseIterable {
    case english = "en_US"
    case italian = "it_IT"
    case french = "fr_FR"
    case indonesian = "id_ID"
    case chinese = "zh_HANS"
    
    var language: String {
        rawValue.components(separatedBy: "_")[0]
    }
    
    var locale: String { rawValue }
}

enum Theme: String, CaseIterable {
    case light
    case dark

    var background: String {
        switch self {
        case .light: return "BackgroundMountainDay"
        case .dark: return "BackgroundMountainNight"
        }
    }
}

enum Orientation: String, CaseIterable {
    case portrait
    case landscape
    
    var uiOrientation: UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscape: return .landscapeLeft
        }
    }
}
