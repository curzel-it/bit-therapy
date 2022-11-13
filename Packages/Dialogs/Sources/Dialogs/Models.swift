import SwiftUI

public enum MessageContent {
    case text(text: String)
    case textInput(placeholder: String, value: Binding<String>)
    case action(title: String, action: () -> Void)
    case singleChoice(options: [String], onSelection: (Int, String) -> Void)
}

extension MessageContent {
    func compile() -> [MessageContent] {
        switch self {
        case .singleChoice(let options, let onSelection):
            return options
                .enumerated()
                .map { index, title in
                    .action(title: title, action: { onSelection(index, title) })
                }
        default: return [self]
        }
    }
}

struct IndexedContent: Identifiable {
    let id: Int
    let content: MessageContent
}

enum EditState {
    case empty
    case populated
    case inUse
    
    static func given(_ value: String?, _ inUse: Bool) -> EditState {
        if inUse { return .inUse }
        if value?.isEmpty ?? true { return .empty }
        return .populated
    }
}
