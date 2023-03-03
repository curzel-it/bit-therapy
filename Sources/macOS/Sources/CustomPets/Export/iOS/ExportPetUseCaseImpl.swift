import Foundation
import SwiftUI
import Yage

class ExportPetUseCaseImpl: ExportPetUseCase {
    func export(item: Species, completion: @escaping (URL?) -> Void) {
        completion(nil)
    }
}
