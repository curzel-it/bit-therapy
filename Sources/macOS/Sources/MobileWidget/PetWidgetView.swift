import NotAGif
import Schwifty
import SwiftUI
import WidgetKit

struct PetWidgetView: View {
    let entry: PetWidgetEntry
    
    var image: ImageFrame? {
        let url = Bundle.main
            .urls(forResourcesWithExtension: "png", subdirectory: "PetsAssets")?
            .first { $0.absoluteString.contains("/\(entry.providerInfo)") }
        guard let url else { return nil }
        return ImageFrame(contentsOf: url)
    }
    
    var body: some View {
        GeometryReader { geo in
            if let image {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(size: geo.size)
            }
        }
        .containerBackground(.fill, for: .widget)
    }
}
