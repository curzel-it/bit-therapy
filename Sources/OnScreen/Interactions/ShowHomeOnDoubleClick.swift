import Schwifty
import SwiftUI
import Yage

open class DoubleClickable: Capability {
    open func onDoubleClick() {
        // ...
    }
}

extension Entity {
    var doubleClick: DoubleClickable? { capability(for: DoubleClickable.self) }
}

class ShowHomeOnDoubleClick: DoubleClickable {
    override func onDoubleClick() {
        MainScene.show()
    }
}
