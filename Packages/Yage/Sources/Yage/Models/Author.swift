import Foundation

public struct Author: Codable {
    public let name: String
    private let link: String?
    
    public var url: URL? { URL(string: link ?? "") }
}
