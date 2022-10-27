import Combine
import Pets
import Schwifty
import SwiftUI
import Yage

class DesktopPet: PetEntity {
    init(of species: Pet, in worldBounds: CGRect, settings: PetsSettings) {
        super.init(of: species, in: worldBounds, settings: settings)
        fps = species.fps
        setupAutoRespawn()
        setupMenu()
        setInitialPosition()
        setInitialDirection()
        setGravity()
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
}

private extension DesktopPet {
    var supportsGravity: Bool {
        capability(for: WallCrawler.self) == nil
    }
    
    func setGravity() {
        setGravity(enabled: settings.gravityEnabled && supportsGravity)
    }
}
