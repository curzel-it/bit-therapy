import AppState
import Foundation

class DesktopObstaclesService: WindowObstaclesService {
        
    override func obstacles(fromWindowFrame frame: CGRect) -> [CGRect] {
        obstacles(from: frame, borderThickness: 10)
    }
    
    func obstacles(from frame: CGRect, borderThickness: CGFloat) -> [CGRect] {
        [CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: borderThickness)]
    }
    
    override func isValidWindow(owner: String, frame: CGRect) -> Bool {
        guard super.isValidWindow(owner: owner, frame: frame) else { return false }
        if owner.contains("desktop pets") {
            return frame.width >= 450 && frame.height >= 450
        }
        return true
    }
    
    override func isValidObstacle(frame: CGRect) -> Bool {
        guard super.isValidObstacle(frame: frame) else { return false }
        return frame.minY > 25 + CGFloat(AppState.global.petSize)
    }
}
