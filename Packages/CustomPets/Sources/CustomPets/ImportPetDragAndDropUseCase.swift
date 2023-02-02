import AppKit
import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

public protocol ImportDragAndDropPetUseCase {
    var supportedTypeId: String { get }
    
    func isAvailable() -> Bool
    func handleDrop(of items: [NSItemProvider], completion: @escaping (Species?, String?) -> Void) -> Bool
}

public enum ImporterError: Error {
    case genericError
    case dropFailed
    case noJsonFile
    case invalidJsonFile
    case speciesAlreadyExists(species: Species)
    case missingAsset(name: String)
}

public class ImportDragAndDropPetUseCaseImpl: ImportDragAndDropPetUseCase {
    @Inject var resources: ResourcesProvider
    @Inject var localization: LocalizedResources
    @Inject var speciesProvider: SpeciesProvider
    
    private let tag = "ImportDragAndDropPetUseCase"
    
    private var importedFolder: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    public let supportedTypeId = "public.file-url"
    
    public init() {}
    
    public func isAvailable() -> Bool {
        importedFolder != nil
    }
    
    public func handleDrop(of items: [NSItemProvider], completion: @escaping (Species?, String?) -> Void) -> Bool {
        guard let item = try? importableItem(from: items) else {
            completion(nil, localization.string(for: .dropFailed))
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
            let species = try importSpecies(fromZip: url)
            Logger.log(tag, "Done!")
            completion(species, nil)
        } catch let error {
            Logger.log(tag, "Import failed: \(error)")
            let actualError = (error as? ImporterError) ?? ImporterError.genericError
            completion(nil, localization.string(for: actualError))
        }
    }
    
    private func importSpecies(fromZip sourceUrl: URL) throws -> Species {
        Logger.log(tag, "Importing", sourceUrl.absoluteString)
        let destinationUrl = try createTempUnzipFolder()
        try FileManager.default.unzipItem(at: sourceUrl, to: destinationUrl)
        return try importSpecies(fromUnzipped: destinationUrl)
    }
    
    private func importSpecies(fromUnzipped unzipped: URL) throws -> Species {
        let importables = try Importables(from: unzipped)
        let species = try importables.parseSpecies()
        let destination = try importedFolder.unwrapped()
        
        try verify(species, with: importables.assets)
        
        let speciesDestination = destination.appendingPathComponent(
            "\(species.id).json", conformingTo: .fileURL
        )
        try FileManager.default.moveItem(at: importables.species, to: speciesDestination)
        
        try importables.assets.forEach {
            let assetDestination = destination.appendingPathComponent(
                $0.lastPathComponent, conformingTo: .fileURL
            )
            try FileManager.default.moveItem(at: $0, to: assetDestination)
        }
        return species
    }
    
    private func verify(_ species: Species, with assetUrls: [URL]) throws {
        let assets = assetUrls.map { $0.lastPathComponent }
        if speciesProvider.allExistingSpecies().contains(species.id) {
            throw ImporterError.speciesAlreadyExists(species: species)
        }
        
        let movementPrefix = "\(species.id)_\(species.movementPath)"
        if !assets.contains(where: { $0.hasPrefix(movementPrefix) }) {
            throw ImporterError.missingAsset(name: movementPrefix)
        }
        
        let dragPrefix = "\(species.id)_\(species.dragPath)"
        if !assets.contains(where: { $0.hasPrefix(dragPrefix) }) {
            throw ImporterError.missingAsset(name: dragPrefix)
        }
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
}

private struct Importables {
    let species: URL
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
        species = jsonUrl
        assets = contents.filter { $0.pathExtension == "png"}
    }
    
    func parseSpecies() throws -> Species {
        guard let jsonContents = try? Data(contentsOf: species) else {
            Logger.log(tag, "Could not read json file")
            throw ImporterError.invalidJsonFile
        }
        guard let species = try? JSONDecoder().decode(Species.self, from: jsonContents) else {
            Logger.log(tag, "Could not decode species")
            throw ImporterError.invalidJsonFile
        }
        Logger.log(tag, "Importing \(species.id)...")
        return species
    }
}

extension Optional {
    func unwrapped() throws -> Wrapped {
        switch self {
        case .some(let value): return value
        case .none: throw OptionalError.isNone
        }
    }
    
    enum OptionalError: Error {
        case isNone
    }
}
