// 
// Pet Therapy.
// 

import AppKit
import EntityWindow
import PetEntity

class MouseDraggablePet: MouseDraggable {
    
    var pet: PetEntity? { body as? PetEntity }
    
    override func mouseDragStarted() {
        pet?.set(state: .drag)
        super.mouseDragStarted()
    }
        
    override func mouseDragEnded(for window: NSWindow?) {
        pet?.set(state: .move)
        super.mouseDragEnded(for: window)
    }
}
