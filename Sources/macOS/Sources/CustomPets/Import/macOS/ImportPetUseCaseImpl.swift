import AppKit
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

class ImportDragAndDropPetUseCaseImpl: ImportDragAndDropPetUseCase {
    @Inject private var importVerifier: ImportVerifier
    @Inject private var resources: CustomPetsResourcesProvider
    
    let supportedTypeId = "public.file-url"
    
    private let tag = "ImportDragAndDropPetUseCase"
    
    private var importedFolder: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    func isAvailable() -> Bool {
        importedFolder != nil
    }
    
    func handleDrop(of items: [NSItemProvider], completion: @escaping (Species?, String?) -> Void) -> Bool {
        guard let item = try? importableItem(from: items) else {
            completion(nil, string(for: .dropFailed))
            return false
        }
        
        item.loadItem(forTypeIdentifier: supportedTypeId, options: nil) { [weak self] data, _ in
            self?.handleDrop(of: data, completion: completion)
        }
        return true
    }
    
    private func handleDrop(of data: NSSecureCoding?, completion: @escaping (Species?, String?) -> Void) {
        do {
            let url = try url(from: data)
            let item = try importItem(fromZip: url)
            Logger.log(tag, "Done!")
            completion(item, nil)
        } catch let error {
            Logger.log(tag, "Import failed: \(error)")
            let actualError = (error as? ImporterError) ?? ImporterError.genericError
            completion(nil, string(for: actualError))
        }
    }
    
    private func importItem(fromZip sourceUrl: URL) throws -> Species {
        Logger.log(tag, "Importing", sourceUrl.absoluteString)
        let destinationUrl = try createTempUnzipFolder()
        try FileManager.default.unzipItem(at: sourceUrl, to: destinationUrl)
        return try importItem(fromUnzipped: destinationUrl)
    }
    
    private func importItem(fromUnzipped unzipped: URL) throws -> Species {
        let importables = try Importables(from: unzipped)
        let destination = try importedFolder.unwrap()
        let item = try importVerifier.verify(json: importables.item, assets: importables.assets)
        
        let itemDestination = destination.appendingPathComponent(
            "\(item.id).json", conformingTo: .fileURL
        )
        try FileManager.default.moveItem(at: importables.item, to: itemDestination)
        
        try importables.assets.forEach {
            let assetDestination = destination.appendingPathComponent(
                $0.lastPathComponent, conformingTo: .fileURL
            )
            try FileManager.default.moveItem(at: $0, to: assetDestination)
        }
        return item
    }
    
    private func createTempUnzipFolder() throws -> URL {
        var destinationUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        destinationUrl.appendPathComponent("temp-import-\(Date().timeIntervalSince1970)")
        
        try? FileManager.default.removeItem(at: destinationUrl)
        
        try FileManager.default.createDirectory(
            at: destinationUrl,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return destinationUrl
    }
    
    private func importableItem(from items: [NSItemProvider]) throws -> NSItemProvider {
        let item = items.first { $0.registeredTypeIdentifiers.first == supportedTypeId }
        if let item {
            return item
        } else {
            Logger.log(tag, "Something dropped, but could not figure it out")
            throw ImporterError.dropFailed
        }
    }
    
    private func url(from data: NSSecureCoding?) throws -> URL {
        guard
            let data = data as? Data,
            let urlString = String(data: data, encoding: .utf8),
            let sourceUrl = URL(string: urlString)
        else {
            Logger.log(tag, "Something dropped, but not a valid url or file")
            throw ImporterError.dropFailed
        }
        return sourceUrl
    }
    
    private func string(for error: ImporterError) -> String {
        switch error {
        case .dropFailed:
            return Lang.CustomPets.genericImportError
        case .noJsonFile:
            return String(format: Lang.CustomPets.missingFiles, "<species>.json")
        case .missingAsset(let name):
            return String(format: Lang.CustomPets.missingFiles, name)
        case .invalidJsonFile:
            return Lang.CustomPets.invalidJson
        case .itemAlreadyExists(let species):
            return String(format: Lang.CustomPets.speciesAlreadyExists, species.id)
        case .genericError:
            return Lang.CustomPets.genericImportError
        }
    }
}

private struct Importables {
    let item: URL
    let assets: [URL]
    
    private let tag = "ImportDragAndDropPetUseCase"
    
    init(from unzippedUrl: URL) throws {
        let zipContents = try FileManager.default
            .contentsOfDirectory(at: unzippedUrl, includingPropertiesForKeys: nil)
            .filter { !$0.lastPathComponent.hasPrefix("__") }
        
        if zipContents.count == 1, let folder = zipContents.first {
            try self.init(from: folder)
        } else {
            try self.init(from: zipContents)
        }
    }
    
    init(from contents: [URL]) throws {
        guard let jsonUrl = contents.first(where: { $0.pathExtension == "json" }) else {
            Logger.log(tag, "Could not find json file")
            throw ImporterError.noJsonFile
        }
        item = jsonUrl
        assets = contents.filter { $0.pathExtension == "png"}
    }
}
