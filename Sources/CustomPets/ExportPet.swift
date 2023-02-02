import AppKit
import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

protocol ExportPetCoordinator {
    func view(for species: Species) -> AnyView
}

class ExportPetButtonCoordinator: ExportPetCoordinator {
    func view(for species: Species) -> AnyView {
        let vm = ExportSpeciesButtonViewModel(species: species)
        return AnyView(
            ExportSpeciesButton(viewModel: vm)
        )
    }
}

private struct ExportSpeciesButton: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: ExportSpeciesButtonViewModel
    
    var body: some View {
        Image(systemName: "square.and.pencil")
            .font(.title)
            .onTapGesture(perform: viewModel.export)
            .sheet(isPresented: viewModel.isAlertShown) {
                VStack(spacing: .zero) {
                    if let title = viewModel.title {
                        Text(title).padding(.top, .lg)
                    }
                    Text(viewModel.message ?? "")
                        .padding(.top, .lg)
                        .padding(.bottom, .lg)
                    HStack {
                        Button(Lang.CustomPets.readTheDocs, action: viewModel.readTheDocs)
                            .buttonStyle(.text)
                        
                        Button(Lang.ok, action: viewModel.clearMessages)
                            .buttonStyle(.regular)
                    }
                }
                .padding(.md)
            }
    }
}

private class ExportSpeciesButtonViewModel: ObservableObject {
    @Published var title: String?
    @Published var message: String?
    
    private let species: Species
    private let exportPetUseCase = ExportPetUseCase()
    
    init(species: Species) {
        self.species = species
    }
    
    lazy var isAlertShown: Binding<Bool> = {
        Binding(
            get: { self.message != nil },
            set: { _ in }
        )
    }()
    
    func export() {
        exportPetUseCase.export(species) { [weak self] destination in
            Task { @MainActor [weak self] in
                self?.doneExporting(to: destination)
            }
        }
    }
    
    private func doneExporting(to destination: URL?) {
        if let destination {
            NSWorkspace.shared.open(destination)
            title = Lang.CustomPets.exportSuccess
            message = Lang.CustomPets.exportSuccessMessage
        } else {
            title = nil
            message = Lang.CustomPets.genericExportError
        }
    }
    
    func readTheDocs() {
        title = nil
        message = nil
        guard let url = URL(string: Lang.Urls.customPetsDocs) else { return }
        NSWorkspace.shared.open(url)
    }
    
    func clearMessages() {
        withAnimation {
            title = nil
            message = nil
        }
    }
}

private class ExportPetUseCase {
    @Inject var assets: PetsAssetsProvider
    
    let tag = "ExportPetUseCase"
    
    func export(_ species: Species, completion: @escaping (URL?) -> Void) {
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
        guard let json = Species.jsonDefinition(for: species) else {
            Logger.log(tag, "Could not find '\(species.id).json'")
            return nil
        }
        let assets = assets.allAssets(for: species.id)
        let urls = [json] + assets
        
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
