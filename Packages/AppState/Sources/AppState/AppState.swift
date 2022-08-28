import Combine
import DesignSystem
import SwiftUI

public class AppState: ObservableObject {
    
    public static let global = AppState()
    
    @Published public var selectedPage: AppPage = .home
            
    @AppStorage("desktopInteractions") public var desktopInteractions: Bool = true
    
    @AppStorage("petId") public var selectedPet: String = "sloth"
    
    @AppStorage("showInMenuBar") public var statusBarIconEnabled = true
    
    @AppStorage("trackingEnabled") public var trackingEnabled = false
    
    @AppStorage("speedMultiplier") private var speedMultiplierValue: Double = 1
    
    @AppStorage("petSize") private var petSizeValue: Double = PetSize.defaultSize
    
    @AppStorage("gravityEnabled") private var gravityEnabledValue = true
    
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
    
    @Published public var gravityEnabled: Bool = true {
        didSet {
            gravityEnabledValue = gravityEnabled
        }
    }
        
    init() {
        petSize = petSizeValue
        speedMultiplier = speedMultiplierValue
        gravityEnabled = gravityEnabledValue
    }
}

public enum AppPage: String, CaseIterable {
    case home
    case settings
    case about
}
