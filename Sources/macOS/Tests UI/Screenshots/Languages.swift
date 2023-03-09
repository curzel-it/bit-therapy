import XCTest

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
