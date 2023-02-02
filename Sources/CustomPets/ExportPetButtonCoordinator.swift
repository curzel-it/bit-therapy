import AppKit
import CustomPets
import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage
import ZIPFoundation

class ExportPetButtonCoordinator {
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
    
    @Inject var exportPetUseCase: ExportPetUseCase
    
    private let species: Species
    
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
        exportPetUseCase.export(item: species) { [weak self] destination in
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
