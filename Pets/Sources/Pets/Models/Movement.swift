//
// Pet Therapy.
//

import CoreGraphics
import Foundation

public struct Movement: Equatable {
    
    static let fly = Movement(type: .fly)
    static let walk = Movement(type: .walk)
    
    public let type: MovementType
    public let path: String
    public let dragPath: String
    
    init(type: MovementType, path: String? = nil) {
        self.type = type
        self.path = path ?? (type == .fly ? "fly" : "walk")
        self.dragPath = path ?? "drag"
    }
}

public enum MovementType {
    case walk
    case fly
    case wallCrawler
}
