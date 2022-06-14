//
// Pet Therapy.
//

import AppKit

public class AnimatedImage {
    
    public let baseName: String
    
    public let frames: [NSImage]
    
    public let frameTime: TimeInterval
    
    public var currentFrame: NSImage? {
        currentFrameIndex < frames.count ? frames[currentFrameIndex] : nil
    }
    
    public var loopDuracy: TimeInterval {
        TimeInterval(frames.count) * frameTime
    }
        
    var currentFrameIndex: Int = 0
    
    private var leftoverTime: TimeInterval = 0
    
    public init(_ name: String, fps: Double, frames: [NSImage]? = nil) {
        self.baseName = name
        self.frameTime = 1 / fps
        self.frames = frames ?? AnimatedImage.frames(for: name)
    }
    
    public func update(after time: TimeInterval) {
        guard frames.count > 0 else { return }
        let timeSinceLastFrameChange = time + leftoverTime
        guard timeSinceLastFrameChange >= frameTime else {
            leftoverTime = timeSinceLastFrameChange
            return
        }
        
        let framesSkipped = Int(floor(timeSinceLastFrameChange / frameTime))
        let usedTime = TimeInterval(framesSkipped) * frameTime
        leftoverTime = timeSinceLastFrameChange - usedTime
        
        let nextFrame = currentFrameIndex + framesSkipped
        let currentFrameIndex = nextFrame % frames.count
        self.currentFrameIndex = currentFrameIndex
    }
}

// MARK: - Load Frames

private extension AnimatedImage {
    
    static func frames(for name: String) -> [NSImage] {
        var frames: [NSImage] = []
        var frameIndex = 0
        while true {
            if let path = Bundle.main.path(forResource: "\(name)-\(frameIndex)", ofType: "png"),
               let image = NSImage(contentsOfFile: path) {
                frames.append(image)
                frameIndex += 1
            } else {
                break
            }
        }
        return frames
    }
}

// MARK: - No Animations

extension AnimatedImage {
 
    public static let none = AnimatedImage("", fps: 1)
}
