import SwiftUI
import Yage

public class ShapeShifter: DKCapability {
    
    var animationDuracy: TimeInterval = 1
    var targetSize: CGSize = .zero
    var delta: CGSize = .zero
    
    public func scaleLinearly(to size: CGSize, duracy: TimeInterval) {
        guard let body = subject else { return }
        
        isEnabled = true
        targetSize = size
        delta = CGSize(
            width: size.width - body.frame.width,
            height: size.height - body.frame.height
        )
        animationDuracy = duracy
        isEnabled = true
    }
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard let body = subject else { return }
        
        let delta = CGSize(
            width: time * (targetSize.width - body.frame.width) / animationDuracy,
            height: time * (targetSize.height - body.frame.height) / animationDuracy
        )
        let newFrame = CGRect(
            x: body.frame.origin.x - delta.width/2,
            y: body.frame.origin.y - delta.height/2,
            width: body.frame.width + delta.width,
            height: body.frame.height + delta.height
        )
        body.set(frame: newFrame)
        
        checkCompletion(given: delta)
    }
    
    private func checkCompletion(given delta: CGSize) {
        let distance = sqrt(pow(delta.width, 2) + pow(delta.height, 2))
        if distance < 0.01 {
            isEnabled = false
        }
    }
}
