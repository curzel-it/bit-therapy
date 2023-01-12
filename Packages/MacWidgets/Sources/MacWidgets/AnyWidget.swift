import Combine
import SwiftUI

extension Widget {
    func wrapped() -> AnyWidget {
        AnyWidget(wrapped: self)
    }
}

class AnyWidget: Widget, Equatable, Hashable, Identifiable {
    fileprivate let _wrapped: any Widget
    
    var id: String { _wrapped.id }
    
    init(wrapped: any Widget) {
        self._wrapped = wrapped
    }
    
    func content() -> NSView {
        _wrapped.content()
    }
    
    func windowFrame() -> AnyPublisher<CGRect, Never> {
        _wrapped.windowFrame()
    }
    
    func windowShown() -> AnyPublisher<Bool, Never> {
        _wrapped.windowShown()
    }
    
    func onWindowClosed() {
        _wrapped.onWindowClosed()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_wrapped.id)
    }
    
    func unwrapped() -> any Widget {
        _wrapped
    }
    
    static func == (lhs: AnyWidget, rhs: AnyWidget) -> Bool {
        lhs.id == rhs.id
    }
}
