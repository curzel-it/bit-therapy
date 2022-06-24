// 
// Pet Therapy.
// 

import AppKit
import EntityWindow
import Pets

class MouseDraggablePet: MouseDraggable {
        
    override func mouseDragStarted() {
        subject?.set(state: .drag)
        super.mouseDragStarted()
    }
        
    override func mouseDragEnded(for window: NSWindow?) {
        subject?.set(state: .move)
        super.mouseDragEnded(for: window)
    }
}
