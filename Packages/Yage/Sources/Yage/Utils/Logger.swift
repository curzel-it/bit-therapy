import Foundation

public protocol Logger {
    func log(_ component: String, _ items: String?...)
}
