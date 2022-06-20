//
// Pet Therapy.
//

import CoreGraphics
import Foundation

public struct Movement: Equatable {
    
    public let type: MovementType
    public let speed: CGFloat
    public let path: String
    public let dragPath: String
    
    init(type: MovementType, speed: CGFloat = 1, path: String? = nil) {
        self.type = type
        self.speed = speed
        self.path = path ?? (type == .fly ? "fly" : "walk")
        self.dragPath = path ?? "drag"
    }
}

public enum MovementType {
    case walk
    case fly
    case wallCrawler
}
