import SwiftUI

public protocol LocalizedContentProvider {
    var close: String { get }
    var desktopApp: String { get }
    var intro: String { get }
    var introComplete: String { get }
}
