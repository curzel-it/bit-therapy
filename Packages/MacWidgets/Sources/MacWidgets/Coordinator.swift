import AppKit
import Combine
import Schwifty
import SwiftUI

public class WidgetsCoordinator {
    let widgets = CurrentValueSubject<Set<AnyWidget>, Never>(Set())
    var windows: [AnyWidget: WidgetWindow] = [:]
    private var disposables = Set<AnyCancellable>()
    
    public init() {
        bindWidgets()
    }
    
    public func add(widget something: any Widget) {
        let widget = something.wrapped()
        guard !isManaged(widget: widget) else { return }
        widgets.send(widgets.value.union(Set([widget])))
    }
    
    public func currentWidgets() -> [any Widget] {
        widgets.value.map { $0.unwrapped() }
    }
    
    public func kill() {
        disposables.removeAll()
        widgets.send(Set())
        windows.values.forEach { $0.close() }
    }
    
    func bindWidgets() {
        widgets
            .scan(([], [])) { previous, current in (previous.1, current) }
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previous, current in
                let newWidgets = current.subtracting(previous)
                self?.spawn(widgets: newWidgets)
            }
            .store(in: &disposables)
    }
    
    func onWindowShown(for widget: AnyWidget) {
        // ...
    }
    
    func onWindowClosed(for widget: AnyWidget) {
        widgets.send(widgets.value.subtracting(Set([widget])))
        windows.removeValue(forKey: widget)
    }
    
    private func spawn(widgets: any Collection<AnyWidget>) {
        widgets.forEach { spawn(widget: $0) }
    }
    
    private func spawn(widget: AnyWidget) {
        let window = WidgetWindow(representing: widget, coordinatedBy: self)
        window.show(self)
        windows[widget] = window
        onWindowShown(for: widget)
    }
    
    private func isManaged(widget: AnyWidget) -> Bool {
        widgets.value.contains(widget)
    }
}
