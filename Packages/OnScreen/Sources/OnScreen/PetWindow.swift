// 
// Pet Therapy.
// 

import AppState
import Biosphere
import Combine
import EntityWindow
import LiveEnvironment
import Pets
import Schwifty
import Sprites
import SwiftUI

class PetWindow: EntityWindow {
    
    private var sizeCanc: AnyCancellable!
    
    public override init(representing entity: Entity, in habitat: LiveEnvironment) {
        super.init(representing: entity, in: habitat)
        bindToSizeSettings()
    }
    
    func bindToSizeSettings() {
        sizeCanc = AppState.global.$petSize.sink { size in
            self.entity.set(size: CGSize(square: size))
        }
    }
    
    override func close() {
        sizeCanc?.cancel()
        sizeCanc = nil
        super.close()
    }
}
