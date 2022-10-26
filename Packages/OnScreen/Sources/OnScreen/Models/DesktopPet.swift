import AppState
import Combine
import Pets
import Schwifty
import SwiftUI
import Yage

extension AppState: Pets.Settings {}

class DesktopPet: PetEntity {
    private var sizeCanc: AnyCancellable!
    private var speedCanc: AnyCancellable!
    private var gravityCanc: AnyCancellable!
    
    init(of species: Pet, in worldBounds: CGRect) {
        super.init(of: species, size: AppState.global.petSize, in: worldBounds, settings: AppState.global)
        fps = species.fps
        setupAutoRespawn()
        setupMenu()
        setInitialPosition()
        setInitialDirection()
        bindSizeToSettings()
        bindSpeedToSettings()
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
    
    private func bindSpeedToSettings() {
        speedCanc = AppState.global.$speedMultiplier.sink { speedMultiplier in
            self.speed = PetEntity.speed(
                for: self.species,
                size: AppState.global.petSize,
                settings: speedMultiplier
            )
        }
    }
    
    override func kill() {
        speedCanc?.cancel()
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
