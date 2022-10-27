import Foundation

public protocol Lang {
    var done: String { get }
    var loading: String { get }
    var restorePurchases: String { get }
    var somethingWentWrong: String { get }
}
