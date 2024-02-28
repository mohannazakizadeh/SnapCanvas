//
//  SnapCanvasUITests.swift
//  SnapCanvasUITests
//
//  Created by Mohanna Zakizadeh on 2/23/24.
//

import XCTest

final class SnapCanvasUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddingCanvasSections() throws {
        let app = XCUIApplication()
        app.launch()
        
        
        // Find the Add Canvas Button
        let addCanvasButton = app.buttons["AddCanvasButton"]
        XCTAssert(addCanvasButton.exists, "The Add Canvas Button does not exist.")
        
        // Find CanvasViewContainer
        let canvasViewContainer = app.otherElements["CanvasViewContainer"]
        XCTAssert(canvasViewContainer.exists, "The CanvasViewContainer does not exist")
        
        let initialCanvasWidth = canvasViewContainer.frame.width
        
        let scrollView = XCUIApplication().scrollViews.firstMatch
        scrollView.scrollToElement(element: addCanvasButton, maxSwipes: 1)
        
        addCanvasButton.tap()
        let finalCanvasWidth = canvasViewContainer.frame.width
        
        XCTAssertEqual(initialCanvasWidth+150, finalCanvasWidth, "Canvas did not add")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
