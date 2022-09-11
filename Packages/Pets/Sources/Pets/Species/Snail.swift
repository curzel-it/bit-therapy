import Foundation
import DesktopKit

extension Pet {
    
    static let snail = Pet(
        id: "snail",
        capabilities: { .defaultsCrawler() },
        fps: 1,
        movementPath: .front,
        dragPath: .front,
        speed: 0.2
    )
    
    static let snailNicky = Pet.snail.shiny(id: "snail_nicky")
}
