import AppIntents
import Foundation
import WidgetKit

struct PetWidgetConfig: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Character"

    @Parameter(title: "Species")
    var species: String
}
