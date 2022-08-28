import Foundation

extension String {
    
    func cleaned() -> String {
        self
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
    }
}
