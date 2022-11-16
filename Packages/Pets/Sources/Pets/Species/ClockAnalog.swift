import Foundation
import Schwifty
import Yage

extension Pet {
    static let clockAnalog = Pet(
        id: "clockanalog",
        capabilities: {
            Capabilities.petAnimations() + [
                AnimatedSprite.self,
                AnalogClock.self
            ]
        },
        fps: 0.5,
        movementPath: .front,
        dragPath: .front,
        speed: 0
    )
}

private class AnalogClock: Clock {
    private let size = ClockSize(mainSpriteWidth: 100)
    
    required init(for subject: Entity) {
        super.init(for: subject)
        subject.frame.size = size.mainSpriteSize
        loadHand(for: "hours")
        loadHand(for: "minutes")
    }
    
    func loadHand(for name: String) {
        guard let subject = subject else { return }
        guard let sprite = subject.spritesProvider?.frames(for: "clockanalog_\(name)").first else { return }
        let layer = ImageLayer(sprite: sprite, in: subject.frame)
        subject.layers.append(layer)
    }
    
    override func update(given timeOfDay: TimeOfDay) {
        guard (subject?.layers.count ?? 0) >= 2 else { return }
        let hoursRad = CGFloat(timeOfDay.hour % 12) * 2 * CGFloat.pi / 12
        let minutesRad = CGFloat(timeOfDay.minute) * 2 * CGFloat.pi / 60
        subject?.layers[0].zAngle = hoursRad
        subject?.layers[1].zAngle = minutesRad
    }
}

private struct ClockSize {
    let mainSpriteWidth: CGFloat
    
    var mainSpriteSize: CGSize {
        CGSize(width: mainSpriteWidth, height: mainSpriteWidth)
    }
}
