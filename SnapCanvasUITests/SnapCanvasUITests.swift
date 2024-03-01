//
//  SnapCanvasUITests.swift
//  SnapCanvasUITests
//
//  Created by Mohanna Zakizadeh on 2/23/24.
//

import XCTest

final class SnapCanvasUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app = nil
    }

    func testAddingCanvasSections() throws {
        
        // Find the Add Canvas Button
        let addCanvasButton = app.buttons["AddCanvasButton"]
        XCTAssert(addCanvasButton.exists, "The Add Canvas Button does not exist.")
        
        // Find CanvasViewContainer
        let canvasViewContainer = app.otherElements["CanvasViewContainer"]
        XCTAssert(canvasViewContainer.exists, "The CanvasViewContainer does not exist")
        
        let initialCanvasWidth = canvasViewContainer.frame.width
        
        let scrollView = app.scrollViews.firstMatch
        scrollView.scrollToElement(element: addCanvasButton, maxSwipes: 1)
        
        addCanvasButton.tap()
        let finalCanvasWidth = canvasViewContainer.frame.width
        
        XCTAssertEqual(ceil(initialCanvasWidth+150), ceil(finalCanvasWidth), "Canvas did not add")
    }
    
    func testTapAddContentButtonOpensSheet() throws {
        openContentBottomSheet()
    }
    
    func testTapOverlayButtonOpensOverlaysView() throws {
        openContentBottomSheet()
        let overlayButton = app.buttons["sparkles"]
        XCTAssert(overlayButton.exists, "The overlays Button does not exist.")
        overlayButton.tap()
        
        let overlaysCollectionView = app.otherElements["OverlaysCollectionView"]
        XCTAssertTrue(overlaysCollectionView.waitForExistence(timeout: 2), "The overlaysCollectionView should be visible after tapping the button.")
        
    }
}

// Extension for helper funcs to prevent code repeating
extension SnapCanvasUITests {
    func openContentBottomSheet() {
        let roundButton = app.buttons["ShowSheetButton"]
        XCTAssert(roundButton.exists, "The show sheet Button does not exist.")
        roundButton.tap()
        
        let addContentSheetView = app.otherElements["AddContentSheetView"]
        XCTAssertTrue(addContentSheetView.waitForExistence(timeout: 2), "The AddContentSheetView should be visible after tapping the button.")
    }
}
