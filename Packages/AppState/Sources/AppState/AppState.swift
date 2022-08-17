//
// Pet Therapy.
//

import Biosphere
import Combine
import DesignSystem
import SwiftUI

public class AppState: ObservableObject {
    
    public static let global = AppState()
    
    @Published public var selectedPage: AppPage = .home
    
    @Published public var mainWindowSize: CGSize = .zero
    
    @Published public var mainWindowFocused: Bool = true
    
    @AppStorage("desktopInteractions") public var desktopInteractions: Bool = true {
        didSet {
            gravityEnabled = gravityEnabled || desktopInteractions
        }
    }
    
    @AppStorage("petId") public var selectedPet: String = "sloth"
    
    @AppStorage("showInMenuBar") public var statusBarIconEnabled = true
    
    @AppStorage("trackingEnabled") public var trackingEnabled = false
    
    @AppStorage("speedMultiplier") private var speedMultiplierValue: Double = 1
    
    @AppStorage("petSize") private var petSizeValue: Double = PetSize.defaultSize
    
    @AppStorage("gravityEnabled") public var gravityEnabled = true {
        didSet {
            Gravity.isEnabled = gravityEnabled
        }
    }
    
    @Published public var speedMultiplier: CGFloat = 1 {
        didSet {
            speedMultiplierValue = speedMultiplier
        }
    }
    
    @Published public var petSize: CGFloat = PetSize.defaultSize {
        didSet {
            petSizeValue = petSize
        }
    }
        
    init() {
        petSize = petSizeValue
        speedMultiplier = speedMultiplierValue
        Gravity.isEnabled = gravityEnabled
    }
}

public enum AppPage: String, CaseIterable {
    case home
    case settings
    case about
}
