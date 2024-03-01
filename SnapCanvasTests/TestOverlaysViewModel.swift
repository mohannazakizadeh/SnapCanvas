//
//  TestOverlaysViewModel.swift
//  SnapCanvasTests
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import XCTest
import Combine
@testable import SnapCanvas

final class TestOverlaysViewModel: XCTestCase {

    var sut: OverlaysViewModel!
    override func setUpWithError() throws {
        sut = OverlaysViewModel(dataProvider: OverlayServiceDataMock(), onRequestDismiss: {_ in })
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testLoadOverlays() throws {
        // given
        let expectation = XCTestExpectation(description: "loaddata")
        let dataSource = OverlayCollectionViewDataSource(collectionView: UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout()), viewModel: sut)
        sut.overlayCollectionViewDataSource = dataSource
        var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
        
        // when
        sut.loadOverlays()
        sut.$urls
            .compactMap{$0}
            .sink { _ in
                expectation.fulfill()
            }.store(in: &disposables)
        
        // then
        wait(for: [expectation], timeout: 3)
        
    }

}
