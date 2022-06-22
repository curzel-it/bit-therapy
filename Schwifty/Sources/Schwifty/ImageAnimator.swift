//
// Pet Therapy.
//

import AppKit

public class ImageAnimator {
    
    public let baseName: String
    
    public let frames: [NSImage]
    
    public let frameTime: TimeInterval = 0.1
        
    public lazy var loopDuracy: TimeInterval = {
        TimeInterval(frames.count) * frameTime
    }()
        
    var currentFrameIndex: Int = 0
    
    private var leftoverTime: TimeInterval = 0
    
    public init(_ name: String, frames: [NSImage]? = nil) {
        self.baseName = name
        self.frames = frames ?? ImageAnimator.frames(for: name)
    }
    
    public func nextFrame(after time: TimeInterval) -> NSImage? {
        guard frames.count > 0 else { return nil }
        let timeSinceLastFrameChange = time + leftoverTime
        guard timeSinceLastFrameChange >= frameTime else {
            leftoverTime = timeSinceLastFrameChange
            return nil
        }
        
        let framesSkipped = Int(floor(timeSinceLastFrameChange / frameTime))
        let usedTime = TimeInterval(framesSkipped) * frameTime
        leftoverTime = timeSinceLastFrameChange - usedTime
        
        let nextIndex = (currentFrameIndex + framesSkipped) % frames.count
        if currentFrameIndex != nextIndex {
            currentFrameIndex = nextIndex
            return frames[nextIndex]
        }
        return nil
    }
}

// MARK: - Load Frames

private extension ImageAnimator {
    
    static func frames(for name: String) -> [NSImage] {
        var frames: [NSImage] = []
        var frameIndex = 0
        while true {
            if let path = Bundle.main.path(forResource: "\(name)-\(frameIndex)", ofType: "png"),
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

// MARK: - No Animations

extension ImageAnimator {
 
    public static let none = ImageAnimator("")
}
