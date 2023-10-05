import WidgetKit
import SwiftUI

@main
struct PetWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "it.curzel.pets.mobilewidget",
            provider: PetWidgetProvider()
        ) { entry in
            PetWidgetView(entry: entry)                
        }
        .configurationDisplayName("BitTherapy")
        .description("BitTherapy Widget")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}
