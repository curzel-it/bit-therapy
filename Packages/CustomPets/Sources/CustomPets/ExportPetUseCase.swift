import AppKit
import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

public protocol ExportPetUseCase {
    func export(species: Species, completion: @escaping (URL?) -> Void)
}

public class ExportPetUseCaseImpl: ExportPetUseCase {
    @Inject var resources: ResourcesProvider
    
    let tag = "ExportPetUseCase"
    
    public init() {}
    
    public func export(species: Species, completion: @escaping (URL?) -> Void) {
        Logger.log(tag, "Exporting", species.id)
        guard let destination = exportUrl(for: species) else { return }
        guard let exportables = exportableUrls(for: species) else { return }
        
        try? FileManager.default.removeItem(at: destination)
        
        do {
            try export(urls: exportables, to: destination)
            completion(destination)
        } catch let error {
            Logger.log(tag, "Failed to export: \(error)")
            completion(nil)
        }
    }
    
    private func exportableUrls(for species: Species) -> [URL]? {
        let urls = resources.allResources(for: species.id)
        
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
    
    private func exportUrl(for species: Species) -> URL? {
        Logger.log(tag, "Asking path to export", species.id)
        let dialog = NSSavePanel()
        dialog.title = "Choose export location"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.nameFieldStringValue = "\(species.id).zip"
        guard dialog.runModal() == .OK, let destination = dialog.url else {
            Logger.log(tag, "No destination path selected, aborting.")
            return nil
        }
        Logger.log(tag, "Selected path", destination.absoluteString)
        return destination
    }
}

enum ExporterError: Error {
    case failedToCreateZipArchive
}
