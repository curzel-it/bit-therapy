import Combine
import SwiftUI

public class FlipHorizontallyWhenGoingLeft: Capability {
    private var directionCanc: AnyCancellable!
    private var stateCanc: AnyCancellable!
    private var lastDirection: CGVector = .zero
    private var lastState: EntityState = .drag
    
    public override func install(on subject: Entity) {
        super.install(on: subject)
        lastDirection = subject.direction
        lastState = subject.state
        
        stateCanc = subject.$state.sink { [weak self] state in
            guard let self = self else { return }
            self.updateYAngle(for: self.lastDirection, state: state)
            self.lastState = state
        }
        directionCanc = subject.$direction.sink { [weak self] direction in
            guard let self = self else { return }
            self.updateYAngle(for: direction, state: self.lastState)
            self.lastDirection = direction
        }
    }
    
    private func updateYAngle(for direction: CGVector, state: EntityState) {
        if case .action(let anim, _) = state, let animDirection = anim.facingDirection {
            updateYAngle(for: animDirection)
        } else {
            updateYAngle(for: direction)
        }
    }
    
    private func updateYAngle(for direction: CGVector) {
        let isGoingLeft = direction.dx < -0.0001
        subject?.yAngle = isGoingLeft ? .pi : .zero
    }
    
    public override func kill() {
        directionCanc?.cancel()
        directionCanc = nil
        super.kill()
    }
}
