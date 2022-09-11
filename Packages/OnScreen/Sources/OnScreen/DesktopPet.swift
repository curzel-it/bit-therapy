import AppState
import DesktopKit
import Combine
import Pets
import Schwifty
import SwiftUI

class DesktopPet: PetEntity {
    
    private var sizeCanc: AnyCancellable!
    private var gravityCanc: AnyCancellable!
    
    init(of species: Pet, in worldBounds: CGRect) {
        super.init(of: species, size: AppState.global.petSize, in: worldBounds)
        fps = species.fps
        setupAutoRespawn()
        setupMenu()
        setInitialPosition()
        setInitialDirection()
        bindSizeToSettings()
        bindGravityToSettings()
    }
    
    private func setInitialPosition() {
        let randomX = CGFloat.random(in: 0.1..<0.75) * worldBounds.width
        let randomY: CGFloat
        
        if capability(for: WallCrawler.self) != nil {
            randomY = worldBounds.height - frame.height
        } else {
            randomY = CGFloat.random(in: 0.1..<0.5) * worldBounds.height
        }
        set(origin: CGPoint(x: randomX, y: randomY))
    }
    
    private func setupAutoRespawn() {
        install(AutoRespawn())
    }
    
    private func setupMenu() {
        install(ShowsMenuOnRightClick())
    }
    
    private func setInitialDirection() {
        set(direction: .init(dx: 1, dy: 0))
    }
    
    private func bindSizeToSettings() {
        sizeCanc = AppState.global.$petSize.sink { size in
            self.set(size: CGSize(square: size))
        }
    }
    
    override func kill() {
        sizeCanc?.cancel()
        gravityCanc?.cancel()
        super.kill()
    }
}

private extension DesktopPet {
    var supportsGravity: Bool {
        capability(for: WallCrawler.self) == nil
    }
    
    func bindGravityToSettings() {
        guard supportsGravity else { return }
        gravityCanc = AppState.global.$gravityEnabled.sink { [weak self] in
            self?.setGravity(enabled: $0)            
        }
    }
}
