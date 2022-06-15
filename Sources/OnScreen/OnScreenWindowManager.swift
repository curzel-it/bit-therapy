// 
// Pet Therapy.
// 

import Combine
import Pets
import Physics
import Schwifty
import SwiftUI

class OnScreenWindowManager: NSObject, NSWindowDelegate {
    
    static var instance: OnScreenWindowManager?
    
    @ObservedObject var appState = AppState.global
    
    private weak var window: NSWindow?
    private weak var view: HostView?
    private weak var viewModel: OnScreenViewModel?
    
    private var boundsCanc: AnyCancellable!
    private var sizeCanc: AnyCancellable!
    private var petCanc: AnyCancellable!
    
    static func setup(with vm: OnScreenViewModel, view: HostView, window: NSWindow) {
        let previousPetFrame = OnScreenWindowManager.instance?.viewModel?.pet.frame
        
        let manager = OnScreenWindowManager(viewModel: vm, view: view, window: window)
        OnScreenWindowManager.instance?.kill()
        OnScreenWindowManager.instance = manager
        view.attach(to: window)
        window.show()
        
        if let previous = previousPetFrame {
            vm.pet.set(frame: previous)
        }
    }
    
    private init(viewModel: OnScreenViewModel, view: HostView, window: NSWindow) {
        self.window = window
        self.viewModel = viewModel
        self.view = view
        super.init()
        moveWindowAccordingToPetBounds()
        resizeAccordingToSettings()
        changePetAccordingToSettings()
    }
    
    func moveWindowAccordingToPetBounds() {
        boundsCanc = viewModel?.pet.$frame.sink { frame in
            guard let window = self.window else { return }
            guard let viewModel = self.viewModel else { return }
            window.update(
                petFrame: frame,
                habitat: viewModel.state.bounds.size
            )
        }
    }
    
    func resizeAccordingToSettings() {
        sizeCanc = AppState.global.$petSize.sink { size in
            guard let viewModel = self.viewModel else { return }
            viewModel.pet.set(size: CGSize(square: size))
        }
    }
    
    func changePetAccordingToSettings() {
        petCanc = AppState.global.$selectedPet.sink { pet in
            guard self.viewModel?.pet.species != pet else { return }
            OnScreenWindow.show(for: pet)
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        kill(closeWindow: false)
    }
    
    func kill(closeWindow: Bool = true) {
        if closeWindow {
            viewModel?.pet.set(state: .smokeOut)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.kill(closeWindow: false)
                self.window?.close()
            }
            return
        }
        viewModel?.kill()
        viewModel = nil
        window = nil
        view?.subviews.forEach { $0.removeFromSuperview() }
        view = nil
        boundsCanc?.cancel()
        boundsCanc = nil
        sizeCanc?.cancel()
        sizeCanc = nil
        petCanc?.cancel()
        petCanc = nil
    }
}

extension NSWindow {
    
    func update(petFrame: CGRect, habitat: CGSize) {
        let newOrigin = CGPoint(
            x: petFrame.minX,
            y: habitat.height - petFrame.maxY
        )
        
        if frame.size == petFrame.size {
            if newOrigin != frame.origin {
                setFrameOrigin(newOrigin)
            }
        } else {
            setFrame(
                CGRect(origin: newOrigin, size: petFrame.size),
                display: true
            )
        }
    }
}
