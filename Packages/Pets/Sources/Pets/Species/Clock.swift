import AppKit
import Foundation
import Squanch
import Yage

extension Pet {
    static let clock = Pet(
        id: "clock",
        capabilities: {
            let size = ClockSize(
                mainSpriteWidth: 126,
                digitsLeadingMargin: 30,
                digitsTopMargin: 86,
                spaceBetweenDigits: 5,
                spaceBetweenHoursAndMinutes: 3,
                digitSize: CGSize(width: 12, height: 9)
            )
            return Capabilities.petAnimations() + [AnimatedSprite(), Clock(size: size)]
        },
        fps: 0.5,
        movementPath: .front,
        dragPath: .front,
        speed: 0
    )
}

private class Clock: Capability {
    private var lastTime: String = ""
    private let size: ClockSize
    var digitSprites: [ImageFrame] = []
    
    init(size: ClockSize) {
        self.size = size
    }
    
    override func install(on subject: Entity) {
        super.install(on: subject)
        subject.set(size: size.mainSpriteSize)
        let species = (subject as? PetEntity)?.species.id ?? "clock"
        digitSprites = subject.spritesProvider?.frames(for: "\(species)_numbers") ?? []
        subject.layers = (0..<4).map { index in
            ImageLayer(
                sprite: digitSprites[index],
                in: size.frameForDigit(at: index)
            )
        }
    }
    
    override func update(with collisions: Collisions, after time: TimeInterval) {
        let newTime = currentTime()
        guard newTime != lastTime else { return }
        lastTime = newTime
        updateSprites(with: newTime)
    }
    
    func currentTime() -> String {
        let date = Date()
        let hours = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        return String(format: "%02d%02d", hours, minutes)
    }
    
    func updateSprites(with hhmm: String) {
        hhmm
            .map { Int("\($0)") ?? 0 }
            .map { digitSprites[$0] }
            .enumerated()
            .forEach { (index, sprite) in
                subject?.layers[index].sprite = sprite
            }
    }
}

private struct ClockSize {
    let mainSpriteWidth: CGFloat
    let digitsLeadingMargin: CGFloat
    let digitsTopMargin: CGFloat
    let spaceBetweenDigits: CGFloat
    let spaceBetweenHoursAndMinutes: CGFloat
    let digitSize: CGSize
    
    func frameForDigit(at index: Int) -> CGRect {
        let hoursMinutesMargin: CGFloat = index > 1 ? marginToMinutes : 0
        let indexInTwo = index % 2
        let leadingMargin = CGFloat(indexInTwo) * digitWidthWithMargin
        
        return CGRect(
            x: digitsLeadingMargin + leadingMargin + hoursMinutesMargin,
            y: digitsTopMargin,
            width: digitSize.width,
            height: digitSize.height
        )
    }
    
    var mainSpriteSize: CGSize {
        CGSize(width: mainSpriteWidth, height: mainSpriteWidth)
    }
    
    private var digitWidthWithMargin: CGFloat {
        digitSize.width + spaceBetweenDigits
    }
    
    private var marginToMinutes: CGFloat {
        digitWidthWithMargin * 2 + spaceBetweenHoursAndMinutes
    }
}
