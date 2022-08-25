//
// Pet Therapy.
//

import DesktopKit
import Foundation

class DesktopObstaclesService: WindowObstaclesService {
        
    override func obstacles(fromWindowFrame frame: CGRect) -> [CGRect] {
        obstacles(from: frame, borderThickness: 20)
    }
    
    func obstacles(from frame: CGRect, borderThickness: CGFloat) -> [CGRect] {
        [CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: borderThickness)]
    }
    
    override func isValid(owner: String, frame: CGRect) -> Bool {
        guard super.isValid(owner: owner, frame: frame) else { return false }
        if owner.contains("desktop pets") {
            return frame.width >= 450 && frame.height >= 450
        }
        return true
    }
}
