import Combine
import DesignSystem
import Foundation
import Pets
import Schwifty
import SwiftUI
import Yage

struct FiltersView: View {
    @EnvironmentObject var petsSelection: PetsSelectionViewModel
    @StateObject private var viewModel = FiltersViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.availableTags, id: \.self) {
                    TagView(tag: $0)
                        .positioned(.leading)
                }
                Spacer()
            }
        }
        .onReceive(viewModel.$selectedTags) { tags in
            petsSelection.filtersChanged(to: tags.filter { $0 != kTagAll })
        }
        .environmentObject(viewModel)
    }
}

private class FiltersViewModel: ObservableObject {
    @Published var availableTags: [String] = []
    @Published var selectedTags = Set([kTagAll])
    
    private var disposables = Set<AnyCancellable>()

    init() {
        Species.all
            .combineLatest($selectedTags)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] species, selected in
                self?.loadTags(from: species, selectedTags: selected)
            }
            .store(in: &disposables)
    }
    
    private func loadTags(from species: [Species], selectedTags: Set<String>) {
        availableTags = [kTagAll] + species
            .flatMap { $0.tags }
            .removeDuplicates(keepOrder: false)
            .sorted()
    }
        
    func isSelected(tag: String) -> Bool {
        selectedTags.contains(tag)
    }
    
    func toggleSelection(tag: String) {
        withAnimation {
            if tag == kTagAll {
                selectedTags.removeAll()
                selectedTags.insert(kTagAll)
                return
            }
            if isSelected(tag: tag) {
                selectedTags.remove(tag)
            } else {
                selectedTags.insert(tag)
            }
            selectedTags.remove(kTagAll)
            if selectedTags.isEmpty {
                selectedTags.insert(kTagAll)
            }
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
