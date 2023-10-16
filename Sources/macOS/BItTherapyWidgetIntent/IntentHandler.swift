//
// Pet Therapy.
//

import Intents
import WidgetKit

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    var petController = PetActionsController()
    
    func providePetTypeOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<CustomPetType>?, Error?) -> Void) {
        
        
        
        var widgetList: [CustomPetType] = []
        
        for petAction in petController.allPetActions{
            widgetList.append(CustomPetType(identifier: petAction.id.uuidString, display: petAction.displayName))
        }
        
        let list = INObjectCollection(items: widgetList)
        
        completion(list, nil)
        
    }
    
    
}

struct PetActions{
    var id: UUID
    var displayName: String
    var prefix: String
    var count: Int
    
    init(displayName: String, prefix: String, count: Int) {
        self.displayName = displayName
        self.prefix = prefix
        self.count = count
        self.id = UUID()
    }
}

class PetActionsController{
    
    var selectedPetAction: String? = UserDefaults.standard.string(forKey: "currentPetAction")
    
    var currentImageIndex: Int = UserDefaults.standard.integer(forKey: "currentImageIndex")
    
    var allPetActions: [PetActions] = [
        PetActions(displayName: "Ape Drag", prefix: "ape_drag-", count: 4),
        PetActions(displayName: "Ape Eat", prefix: "ape_eat-", count: 32),
    ]
    
    func getPetAction(from displayName: String) -> PetActions?{
        return allPetActions.first(where: { $0.displayName == displayName })
    }
    
    func getImageArray(from displayName: String) -> [String]{
        
        guard let petAction = allPetActions.first(where: { $0.displayName == displayName }) else {
            return []
        }
        
        var returnedArray: [String] = []
        
        for i in 0..<petAction.count{
            returnedArray.append("\(petAction.prefix)\(i)")
        }
        
        return returnedArray
    }
    
    func setPetAction(action: String){
        if selectedPetAction == nil || selectedPetAction != action{
            
            
            selectedPetAction = action
            currentImageIndex = 0
            
            UserDefaults.standard.set(action, forKey: "currentPetAction")
            UserDefaults.standard.set(0, forKey: "currentImageIndex")
        }
    }
    
    func nextImage(){
        
        
        let selectedObject = getPetAction(from: selectedPetAction!)
        
        if currentImageIndex == selectedObject!.count - 1{
            currentImageIndex = 0
            UserDefaults.standard.set(0, forKey: "currentImageIndex")
        }else{
            currentImageIndex += 1
            UserDefaults.standard.set(currentImageIndex, forKey: "currentImageIndex")
        }
    }
    
}
