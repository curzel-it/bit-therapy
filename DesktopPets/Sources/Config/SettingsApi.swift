import Foundation

enum SettingsApi {
    
    private static var current: Settings?
        
    static func get() async -> Settings? {
        if let cached = current { return cached }
        guard
            let configUrl = URL(string: "https://curzel.it/pets/config.json"),
            let (data, _) = try? await URLSession.shared.data(for: URLRequest(url: configUrl)),
            let settings = try? JSONDecoder().decode(Settings.self, from: data)
        else { return nil }
        current = settings
        return settings
    }
}

struct Settings: Codable {
    private let surveyUrl: String?
    var survey: URL? { URL(string: surveyUrl ?? "") }
}
