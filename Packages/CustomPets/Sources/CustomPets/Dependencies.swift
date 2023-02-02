import Foundation

public protocol ResourcesProvider {
    func allResources(for itemId: String) -> [URL]
}

public protocol LocalizedResources {
    func string(for: ImporterError) -> String
}

public protocol Item {
    var dragPath: String { get }
    var id: String { get }
    var movementPath: String { get }
}

public protocol ImportVerifier {
    func verify(json: URL, assets: [URL]) throws -> Item
}
