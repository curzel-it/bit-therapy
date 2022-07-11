//
// Pet Therapy.
//

import Foundation

public class Animator<Content> {
    
    public let baseName: String
    public let frames: [Content]
    public let frameTime: TimeInterval = 0.1
    public let loopDuracy: TimeInterval
    
    var onFirstFrameLoaded: ((Int) -> Void)?
    var onLoopCompleted: ((Int) -> Void)?
    var currentFrameIndex: Int = 0
    var completedLoops: Int = 0
    
    private var leftoverTime: TimeInterval = 0
    
    public init(
        baseName: String,
        frames: [Content],
        onFirstFrameLoaded: ((Int) -> Void)? = nil,
        onLoopCompleted: ((Int) -> Void)? = nil
    ) {
        self.baseName = baseName
        self.onFirstFrameLoaded = onFirstFrameLoaded
        self.onLoopCompleted = onLoopCompleted
        self.frames = frames
        self.loopDuracy = TimeInterval(frames.count) * frameTime
    }
    
    public func nextFrame(after time: TimeInterval) -> Content? {
        guard frames.count > 0 else { return nil }
        
        handleFirstFrameOfFirstLoopIfNeeded()
        
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
            checkLoopCompletion(nextIndex: nextIndex)
            return frames[nextIndex]
        }
        return nil
    }
    
    private func handleFirstFrameOfFirstLoopIfNeeded() {
        if completedLoops == 0 && currentFrameIndex == 0 && leftoverTime == 0 {
            onFirstFrameLoaded?(0)
        }
    }
    
    private func checkLoopCompletion(nextIndex: Int) {
        if nextIndex < currentFrameIndex {
            completedLoops += 1
            onLoopCompleted?(completedLoops)
            onFirstFrameLoaded?(completedLoops)
        }
        currentFrameIndex = nextIndex
    }
    
    public func invalidate() {
        self.onFirstFrameLoaded = nil
        self.onLoopCompleted = nil
    }
}
