import AppKit
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

class ExportPetUseCaseImpl: ExportPetUseCase {
    @Inject private var resources: CustomPetsResourcesProvider
    
    private let tag = "ExportPetUseCase"
    
    func export(item: Species, completion: @escaping (URL?) -> Void) {
        Logger.log(tag, "Exporting", item.id)
        guard let destination = exportUrl(for: item) else { return }
        guard let exportables = exportableUrls(for: item) else { return }
        
        try? FileManager.default.removeItem(at: destination)
        
        do {
            try export(urls: exportables, to: destination)
            completion(destination)
        } catch let error {
            Logger.log(tag, "Failed to export: \(error)")
            completion(nil)
        }
    }
    
    private func exportableUrls(for item: Species) -> [URL]? {
        let urls = resources.allResources(for: item.id)
        
        if urls.count > 0 {
            Logger.log(tag, "Found \(urls.count) exportables")
            return urls
        } else {
            Logger.log(tag, "Could not generate export package")
            return nil
        }
    }
    
    private func export(urls: [URL], to destination: URL) throws {
        guard let archive = ZIPFoundation.Archive(url: destination, accessMode: .create) else {
            throw ExporterError.failedToCreateZipArchive
        }
        try urls.forEach {
            try archive.addEntry(with: $0.lastPathComponent, fileURL: $0)
        }
        Logger.log(tag, "Archive created!")
    }
    
    private func exportUrl(for item: Species) -> URL? {
        Logger.log(tag, "Asking path to export", item.id)
        let dialog = NSSavePanel()
        dialog.title = "Choose export location"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.nameFieldStringValue = "\(item.id).zip"
        guard dialog.runModal() == .OK, let destination = dialog.url else {
            Logger.log(tag, "No destination path selected, aborting.")
            return nil
        }
        Logger.log(tag, "Selected path", destination.absoluteString)
        return destination
    }
}
