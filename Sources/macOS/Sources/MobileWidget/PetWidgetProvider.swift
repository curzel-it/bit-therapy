import SwiftUI
import WidgetKit

struct PetWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> PetWidgetEntry {
        PetWidgetEntry(
            date: Date(),
            providerInfo: "sloth_front-"
        )
    }
    
    func timeline(for configuration: PetWidgetConfig, in context: Context) async -> Timeline<PetWidgetEntry> {
        let now = Date()
        let entries = (0..<10).map { index in
            PetWidgetEntry(
                date: now.addingTimeInterval(TimeInterval(index) * 0.1),
                providerInfo: "sloth_front-\(index)"
            )
        }
        return .init(entries: entries, policy: .atEnd)
    }
    
    func snapshot(for config: PetWidgetConfig, in context: Context) async -> PetWidgetEntry {
        PetWidgetEntry(
            date: Date(),
            providerInfo: config.species
        )
    }
}
