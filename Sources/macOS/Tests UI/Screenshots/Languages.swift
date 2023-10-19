import XCTest

enum Language: String, CaseIterable {
    case chinese = "zh_HANS"
    case english = "en_US"
    case french = "fr_FR"
    case indonesian = "id_ID"
    case italian = "it_IT"
    case spanish = "es_ES"
    
    var language: String {
        rawValue.components(separatedBy: "_")[0]
    }
    
    var locale: String { rawValue }
}
