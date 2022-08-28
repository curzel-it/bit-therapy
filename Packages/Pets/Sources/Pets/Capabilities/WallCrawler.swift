import DesktopKit
import SwiftUI

open class WallCrawler: Capability {
    
    override open func update(with collisions: Collisions, after time: TimeInterval) {
        guard let body = subject, isEnabled else { return }
        
        let isGoingUp = body.direction.dy < -0.0001
        let isGoingRight = body.direction.dx > 0.0001
        let isGoingDown = body.direction.dy > 0.0001
        let isGoingLeft = body.direction.dx < -0.0001
        
        if isGoingUp && touchesScreenTop(body) {
            crawlAlongTopBound(body)
            return
        }
        if isGoingRight && touchesScreenRight(body) {
            crawlUpRightBound(body)
            return
        }
        if isGoingDown && touchesScreenBottom(body) {
            crawlAlongBottomBound(body)
            return
        }
        if isGoingLeft && touchesScreenLeft(body) {
            crawlDownLeftBound(body)
            return
        }
    }
    
    private func crawlAlongTopBound(_ body: Entity) {
        body.set(direction: .init(dx: -1, dy: 0))
        body.isUpsideDown = true
        body.set(origin: CGPoint(
            x: body.frame.origin.x, y: 0
        ))
        body.xAngle = .pi
        body.zAngle = 0
        body.yAngle = .pi
    }
    
    private func crawlUpRightBound(_ body: Entity) {
        body.set(direction: .init(dx: 0, dy: -1))
        body.set(origin: CGPoint(
            x: body.habitatBounds.maxX - body.frame.width,
            y: body.frame.origin.y
        ))
        body.xAngle = 0
        body.zAngle = .pi * 1.5
        body.yAngle = 0
    }
    
    private func crawlAlongBottomBound(_ body: Entity) {
        body.set(direction: .init(dx: 1, dy: 0))
        body.set(origin: CGPoint(
            x: body.frame.origin.x,
            y: body.habitatBounds.maxY - body.frame.height
        ))
        body.xAngle = 0
        body.zAngle = 0
        body.yAngle = 0
    }
    
    private func crawlDownLeftBound(_ body: Entity) {
        body.set(direction: .init(dx: 0, dy: 1))
        body.set(origin: CGPoint(
            x: 0, y: body.frame.origin.y
        ))
        body.isUpsideDown = false
        body.xAngle = 0
        body.zAngle = .pi * 0.5
        body.yAngle = 0
    }
    
    private func touchesScreenTop(_ body: Entity) -> Bool {
        let bound = body.habitatBounds.minY
        return body.frame.minY <= bound
    }
    
    private func touchesScreenRight(_ body: Entity) -> Bool {
        let bound = body.habitatBounds.maxX
        return body.frame.maxX >= bound
    }
    
    private func touchesScreenBottom(_ body: Entity) -> Bool {
        let bound = body.habitatBounds.maxY
        return body.frame.maxY >= bound
    }
    
    private func touchesScreenLeft(_ body: Entity) -> Bool {
        let bound = body.habitatBounds.minX
        return body.frame.minX <= bound
    }
}
