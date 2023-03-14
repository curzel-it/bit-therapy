import Combine
import Foundation
import Schwifty
import Yage

protocol MouseTrackingUseCase {
    func position() -> AnyPublisher<CGPoint, Never>
    func start()
    func stop()
}

#if os(macOS)
import AppKit

class MouseTrackingUseCaseImpl: MouseTrackingUseCase {
    private let latestMousePosition = CurrentValueSubject<CGPoint?, Never>(nil)
    private let interval: TimeInterval = 0.5
    private var timer: Timer!
    
    init() {}
    
    func start() {
        timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in self?.update() }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func position() -> AnyPublisher<CGPoint, Never> {
        latestMousePosition
            .removeDuplicates()
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private func update() {
        guard let window = WorldWindow.current else { return }
        guard let screenHeight = Screen.main?.bounds.height else { return }
        
        let positionOnScreen = window
            .convertPoint(toScreen: NSEvent.mouseLocation)
            .offset(x: -window.frame.origin.x)
            .offset(y: -window.frame.origin.y)
        
        let translated: CGPoint = .zero
            .offset(x: positionOnScreen.x)
            .offset(y: screenHeight)
            .offset(y: -positionOnScreen.y)
        
        latestMousePosition.send(translated)
    }
}
#else
class MouseTrackingUseCaseImpl: MouseTrackingUseCase {
    func position() -> AnyPublisher<CGPoint, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func start() {}
    
    func stop() {}
}
#endif
