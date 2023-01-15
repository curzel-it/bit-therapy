import Combine
import SwiftUI

public protocol Widget {
    var id: String { get }
    func content() -> NSView
    func windowFrame() -> AnyPublisher<CGRect, Never>
    func windowShown() -> AnyPublisher<Bool, Never>
    func windowZIndex() -> AnyPublisher<Int, Never>
    func onWindowClosed()
}

extension Widget {
    func windowZIndex() -> AnyPublisher<Int, Never> {
        Just(0).eraseToAnyPublisher()
    }
}

public protocol ImageWidget: Widget {
    func asset() -> AnyPublisher<any Asset, Never>
}

public protocol Asset {
    var id: String { get }
    var image: NSImage? { get }
    var flipHorizontally: Bool { get }
    var flipVertically: Bool { get }
    var zAngle: CGFloat? { get }
}

public protocol MouseDraggable {
    func mouseDragged(to destination: CGPoint, delta: CGSize)
    func mouseDragEnded(at destination: CGPoint, delta: CGSize)
}

public protocol RightClickable {
    func rightClicked(with event: NSEvent)
}

public protocol DoubleClickable {
    func doubleClicked()
}

public protocol PixelArtWidget: ImageWidget {}
