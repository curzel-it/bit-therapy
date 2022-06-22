//
// Pet Therapy.
//

import Biosphere
import Combine
import DesignSystem
import SwiftUI

public class AppState: ObservableObject {
    
    public static var global = AppState()
    
    @Published public var selectedPage: AppPage = .home
        
    @Published public var petSize: CGFloat = PetSize.defaultSize {
        didSet {
            petSizeValue = petSize
        }
    }
    
    @Published public var speedMultiplier: CGFloat = 1 {
        didSet {
            speedMultiplierValue = speedMultiplier
        }
    }
    
    @AppStorage("petId") public var selectedPet: String = "sloth"
    
    @AppStorage("gravityEnabled") public var gravityEnabled = false {
        didSet {
            Gravity.isEnabled = gravityEnabled
        }
    }
    
    @AppStorage("showInMenuBar") public var statusBarIconEnabled = true
    
    @AppStorage("trackingEnabled") public var trackingEnabled = false
    
    @AppStorage("speedMultiplier") private var speedMultiplierValue: Double = 1
    @AppStorage("petSize") private var petSizeValue: Double = PetSize.defaultSize
        
    private init() {
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
