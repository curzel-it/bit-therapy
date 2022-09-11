import Foundation

func printDebug(_ component: String, _ items: String?...) {
    let timestamp = Date().string("HH:mm:ss.SSS")
    let body = logString(for: items)
    print("\(timestamp) [\(component)] \(body)")
}

func logString(for items: [String?]) -> String {
    items
        .map { $0 ?? "nil" }
        .joined(separator: " ")
}

extension Date {
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
