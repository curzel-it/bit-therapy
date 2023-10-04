// 
// Pet Therapy.
// 

import ActivityKit
import WidgetKit
import SwiftUI

struct MobileWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MobileWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MobileWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MobileWidgetAttributes {
    fileprivate static var preview: MobileWidgetAttributes {
        MobileWidgetAttributes(name: "World")
    }
}

extension MobileWidgetAttributes.ContentState {
    fileprivate static var smiley: MobileWidgetAttributes.ContentState {
        MobileWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MobileWidgetAttributes.ContentState {
         MobileWidgetAttributes.ContentState(emoji: "🤩")
     }
}
