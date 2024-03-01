//
//  TestOverlayCollectionViewController.swift
//  SnapCanvasTests
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import XCTest
@testable import SnapCanvas
final class TestOverlayCollectionViewController: XCTestCase {
    
    var viewModel: OverlaysViewModel!
    var viewController: OverlayCollectionViewController!
    var dataProvider: OverlayServiceDataMock!

    override func setUpWithError() throws {
        dataProvider = OverlayServiceDataMock()
        viewModel = OverlaysViewModel(dataProvider: dataProvider, onRequestDismiss: {_ in })
        viewController = OverlayCollectionViewController(overlaysViewModel: viewModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewControllerViewSetup() {
        //when
        viewController.setupViews()
        
        //then
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem, "Close button should be set up.")
        XCTAssertEqual(viewController.title, "Overlays", "ViewController title should be set.")
        XCTAssertEqual(viewController.view.accessibilityIdentifier, "OverlaysCollectionView", "View accessibility identifier should be set.")
    }
    
    func testCollectionViewSetup() throws {
        viewController.configureCollectionView()
        
        let collectionView = viewController.view.subviews.first { $0 is UICollectionView } as? UICollectionView
        XCTAssertNotNil(collectionView, "CollectionView should be configured and added to the view hierarchy.")
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        XCTAssertNotNil(layout, "CollectionView layout should be configured.")
        
        let expectedWidth = (UIScreen.main.bounds.width - (layout?.minimumInteritemSpacing ?? 0) * 3 - 10) / 4
        XCTAssertEqual(layout?.itemSize.width, expectedWidth, "Item size width should match expected calculation.")
        XCTAssertEqual(layout?.itemSize.height, expectedWidth, "Item size height should match expected calculation.")
    }
    
    func testCloseButtonTapped() throws {
        let exp = expectation(description: "Close button action")
        viewModel.onRequestDismiss = { _ in
            exp.fulfill()
        }
        
        viewController.loadViewIfNeeded()
        
        // Simulate button tap
        viewController.closeButtonTapped()
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Close button tap should trigger onRequestDismiss in ViewModel.")
        }
    }

}
