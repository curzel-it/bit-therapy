import Schwifty
import SwiftUI

class EntityDoubleClickHandler {
    static let shared = EntityDoubleClickHandler()
        
    func onDoubleClick() {
        MainScene.show()
    }
}
