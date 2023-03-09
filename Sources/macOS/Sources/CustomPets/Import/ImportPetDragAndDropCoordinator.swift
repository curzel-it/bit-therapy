import Foundation
import Schwifty
import SwiftUI
import Yage

class ImportPetDragAndDropCoordinator {
    func view() -> AnyView {
        let vm = ImportDragAndDropViewModel()
        return AnyView(ImportDragAndDropView(viewModel: vm))
    }
}

private struct ImportDragAndDropView: View {
    @EnvironmentObject var appConfig: AppConfig
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
            URL(string: Lang.Urls.customPetsDocs)?.visit()
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
    @Inject private var assets: PetsAssetsProvider
    @Inject private var speciesProvider: SpeciesProvider
    
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
    
    @Inject var importPetUseCase: ImportDragAndDropPetUseCase
    
    func canImport() -> Bool {
        importPetUseCase.isAvailable()
    }
    
    func clearMessage() {
        message = nil
    }
    
    func handleDrop(of items: [NSItemProvider]) -> Bool {
        importPetUseCase.handleDrop(of: items) { species, errorMessage in
            Task { @MainActor [weak self] in
                guard let self else { return }
                if let species {
                    self.message = Lang.CustomPets.importSuccess
                    self.assets.reloadAssets()
                    self.speciesProvider.register(species)
                } else {
                    self.message = errorMessage ?? Lang.CustomPets.genericImportError
                }
            }
        }
    }
}
