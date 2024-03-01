//
//  CanvasViewModelTests.swift
//  SnapCanvasTests
//
//  Created by Mohanna Zakizadeh on 2/29/24.
//

import XCTest
@testable import SnapCanvas
import SwiftUI

final class CanvasViewModelTests: XCTestCase {
    var viewModel: CanvasViewModel!

    override func setUpWithError() throws {
        let images = [
            ImageToAdd(image: UIImage(systemName: "xmark")!, position:  CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100)),
            ImageToAdd(image: UIImage(systemName: "xmark")!, position: CGPoint(x: 200, y: 200), size: CGSize(width: 100, height: 100))
        ]
        viewModel = CanvasViewModel(numberOfSections: 3, images: images)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testTapGestureRecognizedOnImage() throws {
        // Given
        let tapLocation = CGPoint(x: 60, y: 60)
        
        // When
        viewModel.tapGestureRecognized(at: tapLocation)
        
        // Then
        XCTAssertTrue(viewModel.images[0].isSelected, "First image should be selected.")
        XCTAssertFalse(viewModel.images[1].isSelected, "Second image should not be selected.")
    }
    
    func testTapGestureRecognizedOutsideAnyImage() throws {
        // Given
        let tapLocation = CGPoint(x: 300, y: 300)
        
        // When
        viewModel.tapGestureRecognized(at: tapLocation)
        
        // Then
        for image in viewModel.images {
            XCTAssertFalse(image.isSelected, "No images should be selected.")
        }
    }
    
    func testGetIndexForExistingID() throws {
        // Given: A known setup of images with unique IDs
        let image1ID = viewModel.images[0].id
        let image2ID = viewModel.images[1].id
        
        // When: Requesting the index for the ID of the second image
        let index = viewModel.getIndex(for: image2ID)
        
        // Then: The function should return the correct index of the second image
        XCTAssertNotNil(index, "The index should not be nil for an existing image ID.")
        XCTAssertEqual(index, 1, "The function should return the correct index of the second image.")
    }
    

    func testGetIndexForNonExistingID() throws {
        // Given
        let nonExistingID = UUID()
        
        // When: Requesting the index for a non-existing ID
        let index = viewModel.getIndex(for: nonExistingID)
        
        // Then: The function should return nil
        XCTAssertNil(index, "The index should be nil for a non-existing image ID.")
    }
    
    
}
