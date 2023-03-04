import Combine
import Foundation
import Schwifty
import SwiftUI
import Yage

struct VerticalFiltersView: View {
    @EnvironmentObject var petsSelection: PetsSelectionViewModel
    @StateObject private var viewModel = FiltersViewModel()
        
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.availableTags, id: \.self) {
                    TagView(tag: $0).positioned(.trailing)
                }
                Spacer()
            }
        }
        .onReceive(viewModel.$selectedTag) { tag in
            petsSelection.filterChanged(to: tag == kTagAll ? nil : tag)
        }
        .environmentObject(viewModel)
    }
}

struct HorizontalFiltersView: View {
    @EnvironmentObject var petsSelection: PetsSelectionViewModel
    @StateObject private var viewModel = FiltersViewModel()
        
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.availableTags, id: \.self) {
                    TagView(tag: $0)
                }
                Spacer()
            }
            .padding(.leading, .md)
        }
        .padding(.leading, .inverseMd)
        .onReceive(viewModel.$selectedTag) { tag in
            petsSelection.filterChanged(to: tag == kTagAll ? nil : tag)
        }
        .environmentObject(viewModel)
    }
}

private class FiltersViewModel: ObservableObject {
    @Inject private var speciesProvider: SpeciesProvider
    
    @Published var availableTags: [String] = []
    @Published var selectedTag = kTagAll
    
    private var disposables = Set<AnyCancellable>()

    init() {
        speciesProvider.all
            .combineLatest($selectedTag)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] species, tag in
                self?.loadTags(from: species, selectedTag: tag)
            }
            .store(in: &disposables)
    }
    
    private func loadTags(from species: [Species], selectedTag: String?) {
        availableTags = [kTagAll] + species
            .flatMap { $0.tags }
            .removeDuplicates(keepOrder: false)
            .sorted()
    }
        
    func isSelected(tag: String) -> Bool {
        selectedTag == tag
    }
    
    func toggleSelection(tag: String) {
        withAnimation {
            selectedTag = tag
        }
    }
}

private struct TagView: View {
    @EnvironmentObject var viewModel: FiltersViewModel
    
    let tag: String
    
    var isSelected: Bool {
        viewModel.isSelected(tag: tag)
    }
    
    var background: Color {
        isSelected ? Color.accent : Color.white.opacity(0.8)
    }
    
    var foreground: Color {
        isSelected ? Color.white : Color.black.opacity(0.8)
    }
    
    var body: some View {
        Text(Lang.name(forTag: tag).uppercased())
            .font(.headline)
            .padding(.horizontal)
            .frame(height: DesignSystem.tagsHeight)
            .background(background)
            .cornerRadius(DesignSystem.tagsHeight/2)
            .foregroundColor(foreground)
            .onTapGesture {
                viewModel.toggleSelection(tag: tag)
            }
    }
}

private let kTagAll = "all"
