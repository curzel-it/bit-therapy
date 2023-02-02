import AppKit
import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

protocol ImportPetCoordinator {
    func view() -> AnyView
}

class ImportPetDragAndDropCoordinator: ImportPetCoordinator {
    func view() -> AnyView {
        let vm = ImportDragAndDropViewModel()
        return AnyView(ImportDragAndDropView(viewModel: vm))
    }
}

private struct ImportDragAndDropView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: ImportDragAndDropViewModel
    
    var body: some View {
        if viewModel.canImport() {
            VStack(spacing: .zero) {
                Text(Lang.CustomPets.title).font(.title2.bold()).padding(.bottom, .md)
                Text(Lang.CustomPets.message)
                LinkToDocs().padding(.bottom, .lg)
                DragAndDropView()
            }
            .environmentObject(viewModel)
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

private struct DragAndDropView: View {
    @EnvironmentObject var viewModel: ImportDragAndDropViewModel
    
    var body: some View {
        Text(Lang.CustomPets.dragAreaMessage)
            .padding(.horizontal, .xl)
            .padding(.vertical, .xxl)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                    .fill(Color.label)
            )
            .onDrop(of: viewModel.supportedTypesIdentifiers, isTargeted: nil) { (items) -> Bool in
                viewModel.handleDrop(of: items)
            }
            .sheet(isPresented: viewModel.isAlertShown) {
                VStack(spacing: .zero) {
                    Text(viewModel.message ?? "")
                        .padding(.top, .lg)
                        .padding(.bottom, .lg)
                    Button(Lang.ok, action: viewModel.clearMessage)
                        .buttonStyle(.regular)
                }
                .padding(.md)
            }
            .opacity(0.8)
    }
}

private class ImportDragAndDropViewModel: ObservableObject {
    @Published private(set) var message: String?
    
    lazy var isAlertShown: Binding<Bool> = {
        Binding(
            get: { self.message != nil },
            set: { _ in }
        )
    }()
    
    var supportedTypesIdentifiers: [String] {
        [importPetUseCase.supportedTypeId]
    }
    
    private let importPetUseCase = DragAndDropImportPetUseCase()
    
    func canImport() -> Bool {
        importPetUseCase.isAvailable()
    }
    
    func clearMessage() {
        message = nil
    }
    
    func handleDrop(of items: [NSItemProvider]) -> Bool {
        importPetUseCase.handleDrop(of: items) { imported, errorMessage in
            Task { @MainActor [weak self] in
                guard let self else { return }
                if !imported {
                    self.message = errorMessage ?? Lang.CustomPets.genericImportError
                } else {
                    self.message = Lang.CustomPets.importSuccess
                }
            }
        }
    }
}

private let tag = "DragAndDropImportPetUseCase"

private class DragAndDropImportPetUseCase {
    @Inject var assets: PetsAssetsProvider
    
    private var importedFolder: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    let supportedTypeId = "public.file-url"
    
    func isAvailable() -> Bool {
        importedFolder != nil
    }
    
    func handleDrop(of items: [NSItemProvider], completion: @escaping (Bool, String?) -> Void) -> Bool {
        guard let item = try? importableItem(from: items) else {
            completion(false, ImporterError.dropFailed.localizedMessage)
            return false
        }
        
        item.loadItem(forTypeIdentifier: supportedTypeId, options: nil) { data, _ in
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
            Logger.log(tag, "Import failed: \(error)")
            if let error = error as? ImporterError {
                completion(false, error.localizedMessage)
            } else {
                completion(false, Lang.CustomPets.genericImportError)
            }
        }
    }
    
    private func importSpecies(fromZip sourceUrl: URL) throws {
        Logger.log(tag, "Importing", sourceUrl.absoluteString)
        let destinationUrl = try createTempUnzipFolder()
        try FileManager.default.unzipItem(at: sourceUrl, to: destinationUrl)
        try importSpecies(fromUnzipped: destinationUrl)
        Logger.log(tag, "Done!")
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
        assets.reloadAssets()
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
            Logger.log(tag, "Could not find json file")
            throw ImporterError.noJsonFile
        }
        self.species = jsonUrl
        self.assets = contents.filter { $0.pathExtension == "png"}
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
