//
// Pet Therapy.
//

import WidgetKit
import SwiftUI
import Intents

//class WidgetSingleton{
//    static var shared = WidgetSingleton()
//
//    private init(){}
//
//    var selectedPetAction: PetActions? = nil
//
//    var currentImageIndex: Int = 0
//
//    var timerStarted: Bool = false
//
//    func setNewPetAction(action: PetActions){
//
//        guard let currentSelection = selectedPetAction else{
//            selectedPetAction = action
//            currentImageIndex = 0
//            return
//        }
//
//        if !(currentSelection.displayName == action.displayName){
//            selectedPetAction = action
//            currentImageIndex = 0
//
//        }
//    }
//
//    func startTimer(){
//        if !timerStarted{
//            let timer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timerSec) in
//                        WidgetCenter.shared.reloadAllTimelines()
//                    }
//            timerStarted = true
//        }
//    }
//
//    func nextImage(){
//        print("getting next image. Current index: \(currentImageIndex) for image of \(selectedPetAction?.displayName)")
//        if currentImageIndex == selectedPetAction!.count - 1{
//            currentImageIndex = 0
//        }else{
//            currentImageIndex += 1
//        }
//    }
//}

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), imageName: "ape_eat-2")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, imageName: "ape_eat-2")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        print("inside the get time line function")
        
        let petController = PetActionsController()
        
        var entries: [SimpleEntry] = []
        
        let imageArray = petController.getImageArray(from: configuration.PetType?.displayString ?? "Ape Eat")
        
        petController.setPetAction(action: configuration.PetType?.displayString ?? "Ape Eat")
        
        let currentDate = Date()
        
        let entryDate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration, imageName: imageArray[petController.currentImageIndex])
        
        petController.nextImage()
        
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .second, value: 2, to: currentDate)!))
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1){
            
            WidgetCenter.shared.reloadAllTimelines()
            
        }
        
        completion(timeline)
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let imageName: String
}

struct BitTherapyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        if let imagePath = Bundle.main.path(forResource: "\(entry.imageName).png", ofType: nil){
            if let uiImage = UIImage(contentsOfFile: imagePath){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            else{
                Text("second if else")
            }
        }else{
            Text("first if else")
        }
            
    }
}

struct BitTherapyWidget: Widget {
    let kind: String = "BitTherapyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BitTherapyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct BitTherapyWidget_Previews: PreviewProvider {
    static var previews: some View {
        BitTherapyWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), imageName: "ape_eat-2"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
