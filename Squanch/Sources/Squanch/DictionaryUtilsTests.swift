//
// Pet Therapy.
//

import Foundation

extension Dictionary {
    
    public func merging(with other: [Key: Value]) -> [Key: Value] {
        self.merging(other) { _, newValue in return newValue }
    }
}

extension Dictionary {
    
    public func jsonString() -> String {
        guard let data = try? JSONSerialization.data(
            withJSONObject: self, options: [.prettyPrinted]
        ) else { return "n/a" }
        return String(data: data, encoding: .utf8) ?? "n/a"
    }
}
