import AppKit
import XCTest

@testable import Desktop_Pets

final class ImageInterpolationUseCaseTests: XCTestCase {
    let image50by50 = NSImage().scaled(to: .init(square: 50), with: .default)
    
    let useCase = ImageInterpolationUseCase()
    
    func testDoesNotInterpolateOnRetinaDisplays() throws {
        let mode2 = useCase.interpolationMode(for: image50by50, renderingSize: .s75by75, screenScale: 2)
        XCTAssertEqual(mode2, .none)
        
        let mode3 = useCase.interpolationMode(for: image50by50, renderingSize: .s75by75, screenScale: 3)
        XCTAssertEqual(mode3, .none)
    }
    
    func testDoesNotInterpolatePerfectScaling() throws {
        let mode1x = useCase.interpolationMode(for: image50by50, renderingSize: .s50by50, screenScale: 1)
        XCTAssertEqual(mode1x, .none)
        
        let mode2x = useCase.interpolationMode(for: image50by50, renderingSize: .s100by100, screenScale: 1)
        XCTAssertEqual(mode2x, .none)
    }
    
    func testDoesInterpolateWhenRenderingSizeIsSmallerThanImage() throws {
        let mode1 = useCase.interpolationMode(for: image50by50, renderingSize: .s10by10, screenScale: 1)
        XCTAssertEqual(mode1, .default)
        
        let mode2 = useCase.interpolationMode(for: image50by50, renderingSize: .s10by10, screenScale: 2)
        XCTAssertEqual(mode2, .default)
    }
    
    func testDoesInterpolateWhenRenderingSizeIsNotAMultipleOfImageSize() throws {
        let mode1 = useCase.interpolationMode(for: image50by50, renderingSize: .s10by10, screenScale: 2)
        XCTAssertEqual(mode1, .default)
        
        let mode2 = useCase.interpolationMode(for: image50by50, renderingSize: .s65by65, screenScale: 1)
        XCTAssertEqual(mode2, .default)
        
        let mode3 = useCase.interpolationMode(for: image50by50, renderingSize: .s75by75, screenScale: 1)
        XCTAssertEqual(mode3, .none)
        
        let mode4 = useCase.interpolationMode(for: image50by50, renderingSize: .s80by80, screenScale: 1)
        XCTAssertEqual(mode4, .none)
    }

}

private extension CGSize {
    static let s100by100 = CGSize(square: 100)
    static let s80by80 = CGSize(square: 80)
    static let s75by75 = CGSize(square: 75)
    static let s65by65 = CGSize(square: 65)
    static let s50by50 = CGSize(square: 50)
    static let s10by10 = CGSize(square: 10)
}
