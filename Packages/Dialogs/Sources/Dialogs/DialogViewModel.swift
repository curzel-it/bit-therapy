import DesignSystem
import Schwifty
import SwiftUI

class DialogViewModel: ObservableObject {
    @Published var textOffsetY: CGFloat = 0
    
    let contents: [IndexedContent]
    let styler: Styler = Styler()
    
    var textOffsetLines: Int = 0 {
        didSet {
            Task { @MainActor in
                withAnimation {
                    textOffsetY = -CGFloat(textOffsetLines) * actualLineHeight
                }
            }
        }
    }
    
    lazy var actualLineHeight: CGFloat = {
        styler.lineSpacing + styler.fontSize
    }()
    
    lazy var textHeight: CGFloat = {
        CGFloat(styler.displayLines) * actualLineHeight
    }()
    
    var totalNumberOfLines: Int = 40
    
    var canShowNext: Bool {
        textOffsetLines < totalNumberOfLines
    }
    
    var canShowPrevious: Bool {
        textOffsetLines > 0
    }
    
    init(contents: [MessageContent]) {
        self.contents = ([.text(text: "")] + contents)
            .enumerated()
            .map { IndexedContent(id: $0, content: $1) }
    }
    
    func setup(width: CGFloat) {
        let lines = contentHeight(width: width) / actualLineHeight
        totalNumberOfLines = Int(lines) - styler.displayLines
    }
    
    private func contentHeight(width: CGFloat) -> CGFloat {
        let spacing = CGFloat(contents.count) * styler.contentSpacing
        let contentHeight = contents
            .map { height(content: $0.content, width: width) }
            .reduce(0, +)
        return contentHeight + spacing
    }
    
    private func height(content: MessageContent, width: CGFloat) -> CGFloat {
        switch content {
        case .text(let text): return height(text: text, width: width)
        case .textInput: return DesignSystem.buttonsHeight
        case .action: return DesignSystem.buttonsHeight
        case .singleChoice(let options, _): return height(options: options, width: width)
        }
    }
    
    private func height(text: String, width: CGFloat) -> CGFloat {
        let charsPerLine = Int(width / styler.fontSize)
        var lines = 1
        var currentLineChars = 0
        for char in text {
            currentLineChars += 1
            if currentLineChars == charsPerLine || char == "\n" {
                lines += 1
                currentLineChars = 0
            }
        }
        return CGFloat(lines) * actualLineHeight
    }
    
    private func height(options: [String], width: CGFloat) -> CGFloat {
        let singleOptionHeight = height(content: .action(title: "", action: {}), width: width)
        let optionsHeight = singleOptionHeight * styler.contentSpacing
        let spacing = CGFloat(options.count) * styler.contentSpacing
        return optionsHeight + spacing
    }
    
    func next() {
        textOffsetLines += 1
    }
    
    func previous() {
        textOffsetLines -= 1
    }
}
