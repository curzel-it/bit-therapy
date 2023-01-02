//
// Pet Therapy.
//

import AppKit
import Foundation
import Pets
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

struct PetsImporterDragAndDropView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.creatorMode && PetsImporter.shared.canImport() {
            VStack(spacing: .zero) {
                Text(Lang.CustomPets.title).font(.title2.bold()).padding(.bottom, .md)
                Text(Lang.CustomPets.message)
                LinkToDocs().padding(.bottom, .lg)
                DragAndDrop()
            }
        }
    }
}

private struct LinkToDocs: View {
    var body: some View {
        Button(Lang.CustomPets.readTheDocs) {
            guard let url = URL(string: Lang.Urls.customPetsDocs) else { return }
            NSWorkspace.shared.open(url)
        }
        .buttonStyle(.text)
    }
}

private struct DragAndDrop: View {
    @State var message: String?
    
    var body: some View {
        Text(Lang.CustomPets.dragAreaMessage)
            .padding(.horizontal, .xl)
            .padding(.vertical, .xxl)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                    .fill(Color.label)
            )
            .onDrop(of: [PetsImporter.shared.registeredTypeIdentifier], isTargeted: nil) { (items) -> Bool in
                PetsImporter.shared.handleDrop(of: items) { imported, errorMessage in
                    if !imported {
                        self.message = errorMessage ?? Lang.CustomPets.genericImportError
                    } else {
                        self.message = Lang.CustomPets.importSuccess
                    }
                }
            }
            .sheet(isPresented: Binding(get: { return message != nil }, set: { _, _ in })) {
                VStack(spacing: .zero) {
                    Text(message ?? "")
                        .padding(.top, .lg)
                        .padding(.bottom, .lg)
                    Button(Lang.ok) { message = nil }
                        .buttonStyle(.regular)
                }
                .padding(.md)
            }
            .opacity(0.8)
    }
}

private class PetsImporter {
    static let shared = PetsImporter()
    
    private var importedFolder: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    let registeredTypeIdentifier = "public.file-url"
    
    func canImport() -> Bool {
        importedFolder != nil
    }
    
    func handleDrop(of items: [NSItemProvider], completion: @escaping (Bool, String?) -> Void) -> Bool {
        guard let item = try? importableItem(from: items) else {
            completion(false, ImporterError.dropFailed.localizedMessage)
            return false
        }
        
        item.loadItem(forTypeIdentifier: registeredTypeIdentifier, options: nil) { data, _ in
            self.handleDrop(of: data, completion: completion)
        }
        return true
    }
    
    private func handleDrop(of data: NSSecureCoding?, completion: @escaping (Bool, String?) -> Void) {
        do {
            let url = try url(from: data)
            try importSpecies(fromZip: url)
            completion(true, nil)
        } catch let error {
            Logger.log("Importer", "Import failed: \(error)")
            if let error = error as? ImporterError {
                completion(false, error.localizedMessage)
            } else {
                completion(false, Lang.CustomPets.genericImportError)
            }
        }
    }
    
    private func importSpecies(fromZip sourceUrl: URL) throws {
        Logger.log("Importer", "Importing", sourceUrl.absoluteString)
        let destinationUrl = try createTempUnzipFolder()
        try FileManager.default.unzipItem(at: sourceUrl, to: destinationUrl)
        try importSpecies(fromUnzipped: destinationUrl)
        Logger.log("Importer", "Done!")
    }
    
    private func importSpecies(fromUnzipped unzipped: URL) throws {
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
        PetsAssetsProvider.shared.reloadAssets()
        Species.register(species)
    }
    
    private func verify(_ species: Species, with assetUrls: [URL]) throws {
        let assets = assetUrls.map { $0.lastPathComponent }
        if Species.all.value.contains(species) {
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
        destinationUrl.appendPathComponent("temp-import")
        
        try? FileManager.default.removeItem(at: destinationUrl)
        
        try FileManager.default.createDirectory(
            at: destinationUrl,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return destinationUrl
    }
    
    private func importableItem(from items: [NSItemProvider]) throws -> NSItemProvider {
        let item = items.first { $0.registeredTypeIdentifiers.first == registeredTypeIdentifier }
        if let item {
            return item
        } else {
            Logger.log("Importer", "Something dropped, but could not figure it out")
            throw ImporterError.dropFailed
        }
    }
    
    private func url(from data: NSSecureCoding?) throws -> URL {
        guard
            let data = data as? Data,
            let urlString = String(data: data, encoding: .utf8),
            let sourceUrl = URL(string: urlString)
        else {
            Logger.log("Importer", "Something dropped, but not a valid url or file")
            throw ImporterError.dropFailed
        }
        return sourceUrl
    }
}

enum ImporterError: Error {
    case dropFailed
    case noJsonFile
    case invalidJsonFile
    case speciesAlreadyExists(species: Species)
    case missingAsset(name: String)
    
    var localizedMessage: String {
        switch self {
        case ImporterError.dropFailed:
            return Lang.CustomPets.genericImportError
        case ImporterError.noJsonFile:
            return String(format: Lang.CustomPets.missingFiles, "<species>.json")
        case ImporterError.missingAsset(let name):
            return String(format: Lang.CustomPets.missingFiles, name)
        case ImporterError.invalidJsonFile:
            return Lang.CustomPets.invalidJson
        case ImporterError.speciesAlreadyExists(let species):
            return String(format: Lang.CustomPets.speciesAlreadyExists, species.id)
        }
    }
}

private struct Importables {
    let species: URL
    let assets: [URL]
    
    init(from unzippedUrl: URL) throws {
        let folders = try FileManager.default.contentsOfDirectory(
            at: unzippedUrl,
            includingPropertiesForKeys: nil
        )
        let unzippedFolder = try folders.first { !$0.lastPathComponent.hasPrefix("__") }.unwrapped()
        let contents = try FileManager.default.contentsOfDirectory(
            at: unzippedFolder,
            includingPropertiesForKeys: nil
        )
        guard let jsonUrl = contents.first(where: { $0.pathExtension == "json" }) else {
            Logger.log("Importer", "Could not find json file")
            throw ImporterError.noJsonFile
        }
        self.species = jsonUrl
        self.assets = contents.filter { $0.pathExtension != "json"}
    }
    
    func parseSpecies() throws -> Species {
        guard let jsonContents = try? Data(contentsOf: species) else {
            Logger.log("Importer", "Could not read json file")
            throw ImporterError.invalidJsonFile
        }
        guard let species = try? JSONDecoder().decode(Species.self, from: jsonContents) else {
            Logger.log("Importer", "Could not decode species")
            throw ImporterError.invalidJsonFile
        }
        Logger.log("Importer", "Importing \(species.id)...")
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
