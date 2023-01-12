import Combine
import XCTest

@testable import MacWidgets

class TestWidget: Widget {
    let id: String
    let isAlive = CurrentValueSubject<Bool, Never>(true)
    let frame = CurrentValueSubject<CGRect, Never>(.zero)
    var windowHasBeenClosed: Bool = false
    
    init(id: String) {
        self.id = id
    }
    
    func content() -> NSView {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func windowFrame() -> AnyPublisher<CGRect, Never> {
        frame.eraseToAnyPublisher()
    }
    
    func windowShown() -> AnyPublisher<Bool, Never> {
        isAlive.eraseToAnyPublisher()
    }
    
    func onWindowClosed() {
        windowHasBeenClosed = true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TestWidget, rhs: TestWidget) -> Bool {
        lhs.id == rhs.id
    }
}
