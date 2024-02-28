//
//  Extension.swift
//  SnapCanvasUITests
//
//  Created by Mohanna Zakizadeh on 2/24/24.
//

import XCTest

extension XCUIElement {
    func scrollToElement(element: XCUIElement, maxSwipes: Int = 10) {
        // Check if the element is already hittable (visible and interactable)
        for _ in 0..<maxSwipes {
//            if element.isHittable { return }
            let startCoord = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            let endCoord = self.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1)) 
            startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
        }
    }
}
