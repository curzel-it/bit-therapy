import AppKit
import Foundation

public class WorldWindowsProvider {
    public init() {}
    
    public func window(representing world: RenderableWorld) -> NSWindow {
        WorldWindow(representing: world)
    }
}

protocol EntityView: NSView {
    var entityId: String { get }
    var zIndex: Int { get }
    func update()
}
