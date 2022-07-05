//
// Pet Therapy.
//

import Biosphere
import Combine
import SwiftUI

public class GameState: ObservableObject {
    
    public static let global = GameState()
    
    @Published public var mainWindowSize: CGSize = .zero
    
    @Published public var mainWindowFocused: Bool = true
    
    @Published public var petSize: CGFloat = 50
            
    init() {
        // ...
    }
}
