//
// Pet Therapy.
//

import AppKit
import Schwifty
import Squanch

public class PetsAssets {
    
    public static func animator(
        baseName: String,
        onFirstFrameLoaded: ((Int) -> Void)? = nil,
        onLoopCompleted: ((Int) -> Void)? = nil
    ) -> ImageAnimator {
        ImageAnimator(
            baseName: baseName,
            frames: frames(for: baseName, in: .main),
            onFirstFrameLoaded: onFirstFrameLoaded,
            onLoopCompleted: onLoopCompleted
        )
    }
    
    private static func frames(for name: String, in bundle: Bundle) -> [NSImage] {
        var frames: [NSImage] = []
        var frameIndex = 0
        while true {
            if let path = bundle.path(forResource: "\(name)-\(frameIndex)", ofType: "png"),
               let image = NSImage(contentsOfFile: path) {
                frames.append(image)
            } else {
                if frameIndex != 0 { break }
            }
            frameIndex += 1
        }
        return frames
    }
}
