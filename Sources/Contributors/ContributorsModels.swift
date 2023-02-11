import SwiftUI

struct Contributors {
    static var all: [Contributor] = {
        guard let url = Bundle.main.url(forResource: "contributors", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([Contributor].self, from: data)
        else { return [] }
        return items
    }()
}

struct Contributor: Codable {
    let name: String
    let roles: [Role]
    let pets: [String]
    let link: String?
    let thumbnail: String?
}

enum Role: String, Codable {
    case artist
    case developer
    case moderator
    case owner
    case patreon
    case translator
    
    var isHightlighted: Bool {
        self == .owner || self == .patreon
    }
}

extension Role: CustomStringConvertible {
    var description: String {
        "contributors.\(rawValue)".localized().uppercased()
    }
}
