import Combine
import NotAGif
import SwiftUI
import Yage

struct PetPreview: View {
    @EnvironmentObject private var selectionViewModel: PetsSelectionViewModel
    @StateObject private var viewModel: PetPreviewViewModel
    
    let size: CGFloat = 80
    
    init(species: Species) {
        let vm = PetPreviewViewModel(species: species)
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack {
            if let frame = viewModel.previewImage {
                Image(frame: frame)
                    .pixelArt()
                    .frame(width: size, height: size)
            }
            Text(viewModel.title).multilineTextAlignment(.center)
        }
        .frame(minWidth: size)
        .frame(maxWidth: .infinity)
        .frame(minHeight: size)
        .onTapGesture {
            selectionViewModel.showDetails(of: viewModel.species)
        }
    }
}

private class PetPreviewViewModel: ObservableObject {
    @Inject private var assets: PetsAssetsProvider
    @Inject private var names: SpeciesNamesRepository
    
    @Published var title = ""
    
    let species: Species
    var previewImage: ImageFrame?
    
    private var disposables = Set<AnyCancellable>()
    
    init(species: Species) {
        self.species = species
        loadImage()
        bindTitle()
    }
    
    func loadImage() {
        let path = assets.frames(for: species.id, animation: "front").first
        previewImage = assets.image(sprite: path)
    }
    
    private func bindTitle() {
        names.name(forSpecies: species.id)
            .sink { [weak self] name in self?.title = name }
            .store(in: &disposables)
    }
}
