import AppKit

public protocol EntityView: NSView {
    var zIndex: Int { get }
    func update()
}
