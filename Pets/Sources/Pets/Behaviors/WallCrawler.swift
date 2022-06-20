//
// Pet Therapy.
//

import Biosphere
import SwiftUI

open class WallCrawler: Capability {
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard let body = body, isEnabled else { return }
        
        let isGoingUp = body.direction.dy < -0.0001
        let isGoingRight = body.direction.dx > 0.0001
        let isGoingDown = body.direction.dy > 0.0001
        let isGoingLeft = body.direction.dx < -0.0001
        
        if isGoingUp && touchesScreenTop() {
            body.set(direction: .init(dx: -1, dy: 0))
            body.isUpsideDown = true
            body.set(origin: CGPoint(
                x: body.frame.origin.x, y: 0
            ))
            return
        }
        
        if isGoingRight && touchesScreenRight() {
            body.set(direction: .init(dx: 0, dy: -1))
            body.set(origin: CGPoint(
                x: body.habitatBounds.maxX - body.frame.width,
                y: body.frame.origin.y
            ))
            return
        }
        if isGoingDown && touchesScreenBottom() {
            body.set(direction: .init(dx: 1, dy: 0))
            body.set(origin: CGPoint(
                x: body.frame.origin.x,
                y: body.habitatBounds.maxY - body.frame.height
            ))
            return
        }
        if isGoingLeft && touchesScreenLeft() {
            body.set(direction: .init(dx: 0, dy: 1))
            body.set(origin: CGPoint(
                x: 0, y: body.frame.origin.y
            ))
            body.isUpsideDown = false
            return
        }
    }
    
    func touchesScreenTop() -> Bool {
        guard let body = body else { return false }
        let bound = body.habitatBounds.minY
        return body.frame.minY <= bound
    }
    
    func touchesScreenRight() -> Bool {
        guard let body = body else { return false }
        let bound = body.habitatBounds.maxX
        return body.frame.maxX >= bound
    }
    
    func touchesScreenBottom() -> Bool {
        guard let body = body else { return false }
        let bound = body.habitatBounds.maxY
        return body.frame.maxY >= bound
    }
    
    func touchesScreenLeft() -> Bool {
        guard let body = body else { return false }
        let bound = body.habitatBounds.minX
        return body.frame.minX <= bound
    }
}
