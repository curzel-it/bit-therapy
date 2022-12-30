import SwiftUI

public class ShapeShifter: Capability {
    var animationDuracy: TimeInterval = 1
    var targetSize: CGSize = .zero
    var delta: CGSize = .zero

    public func scaleLinearly(to size: CGSize, duracy: TimeInterval) {
        guard let subject else { return }
        targetSize = size
        delta = CGSize(
            width: size.width - subject.frame.width,
            height: size.height - subject.frame.height
        )
        animationDuracy = duracy
        isEnabled = true
    }

    override public func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let subject else { return }

        let delta = CGSize(
            width: time * delta.width / animationDuracy,
            height: time * delta.height / animationDuracy
        )
        let newFrame = CGRect(
            x: subject.frame.origin.x - delta.width / 2,
            y: subject.frame.origin.y - delta.height / 2,
            width: subject.frame.width + delta.width,
            height: subject.frame.height + delta.height
        )
        subject.frame = newFrame

        checkCompletion(given: delta)
    }

    private func checkCompletion(given delta: CGSize) {
        let distance = sqrt(pow(delta.width, 2) + pow(delta.height, 2))
        if distance < 0.01 {
            isEnabled = false
        }
    }
}
