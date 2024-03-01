//
//  Extension.swift
//  SnapCanvasUITests
//
//  Created by Mohanna Zakizadeh on 2/24/24.
//

import XCTest

extension XCUIElement {
    func scrollToElement(element: XCUIElement, maxSwipes: Int = 10) {
        for _ in 0..<maxSwipes {
            let startCoord = self.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 0.0))
            let endCoord = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.0))
            startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
        }
    }
}
