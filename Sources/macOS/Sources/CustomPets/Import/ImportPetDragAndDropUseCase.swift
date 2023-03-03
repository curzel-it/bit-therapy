import Foundation
import Schwifty
import SwiftUI
import Yage

protocol ImportDragAndDropPetUseCase {
    var supportedTypeId: String { get }
    
    func isAvailable() -> Bool
    func handleDrop(of items: [NSItemProvider], completion: @escaping (Species?, String?) -> Void) -> Bool
}

enum ImporterError: Error {
    case genericError
    case dropFailed
    case noJsonFile
    case invalidJsonFile
    case itemAlreadyExists(item: Species)
    case missingAsset(name: String)
}
