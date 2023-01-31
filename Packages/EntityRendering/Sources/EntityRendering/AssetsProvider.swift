import AppKit
import Foundation

public protocol AssetsProvider {
    func image(sprite: String?) -> NSImage?
}
