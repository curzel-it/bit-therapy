// 
// Pet Therapy.
// 

import AppKit
import Foundation
import Pets
import Schwifty
import Yage
import ZIPFoundation

class PetsExporter {
    static let shared = PetsExporter()
    
    func export(species: Species, completion: @escaping (URL?) -> Void) {
        Logger.log("Exporter", "Exporting", species.id)
        guard let destination = exportUrl(for: species) else { return }
        guard let exportables = exportableUrls(for: species) else { return }
        
        try? FileManager.default.removeItem(at: destination)
        
        do {
            try export(urls: exportables, to: destination)
            completion(destination)
        } catch let error {
            Logger.log("Exporter", "Failed to export: \(error)")
            completion(nil)
        }
    }
    
    private func exportableUrls(for species: Species) -> [URL]? {
        guard let json = Species.jsonDefinition(for: species) else {
            Logger.log("Exporter", "Could not find '\(species.id).json'")
            return nil
        }
        let assets = PetsAssetsProvider.shared.allAssets(for: species.id)
        let urls = [json] + assets
        
        if urls.count > 0 {
            Logger.log("Exporter", "Found \(urls.count) exportables")
            return urls
        } else {
            Logger.log("Exporter", "Could not generate export package")
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
        Logger.log("Exporter", "Archive created!")
    }
    
    private func exportUrl(for species: Species) -> URL? {
        Logger.log("Exporter", "Asking path to export", species.id)
        let dialog = NSSavePanel()
        dialog.title = "Choose export location"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.nameFieldStringValue = "\(species.id).zip"
        guard dialog.runModal() == .OK, let destination = dialog.url else {
            Logger.log("Exporter", "No destination path selected, aborting.")
            return nil
        }
        Logger.log("Exporter", "Selected path", destination.absoluteString)
        return destination
    }
}

enum ExporterError: Error {
    case failedToCreateZipArchive
}
