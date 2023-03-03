import Foundation
import Schwifty
import SwiftUI
import Yage

protocol ExportPetUseCase {
    func export(item: Species, completion: @escaping (URL?) -> Void)
}

enum ExporterError: Error {
    case failedToCreateZipArchive
}

