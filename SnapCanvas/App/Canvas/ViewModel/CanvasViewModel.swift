//
//  CanvasViewModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/23/24.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    @Published var numberOfSections: Int = 3
    @Binding var images: [ImageToAdd]
    @Published var showHorizontalSnapIndicator: Bool = false
    @Published var showVerticalSnapIndicator: Bool = false
    @Published var snapIndicatorPosition: CGPoint = .zero
    
    let snapThreshold: CGFloat = 5
    
    init(numberOfSections: Int, images: Binding<[ImageToAdd]>) {
        self.numberOfSections = numberOfSections
        self._images = images
    }
    
    func tapGestureRecognized(at location: CGPoint) {
        if let index = images.firstIndex(where: { imageModel in
            let imageFrame = CGRect(x: imageModel.position.x - (imageModel.size.width/2), y: imageModel.position.y - (imageModel.size.height/2), width: imageModel.size.width, height: imageModel.size.height)
            return imageFrame.contains(location)
        }) {
            images[index].isSelected = true
        } else {
            for (index, _) in images.enumerated() {
                images[index].isSelected = false
            }
        }
    }
    
    func addSection() {
        numberOfSections += 1
    }
    
    func getIndex(for id: UUID) -> Int? {
        images.firstIndex(where: { $0.id == id })
    }
    
    func snapDragging(for id: UUID, location: CGPoint, geometry: GeometryProxy) {
        if let index = getIndex(for: id) {
            var newPosition = location
            // Example: Snap to left or right edge
            if abs(newPosition.x - snapThreshold) < snapThreshold {
                newPosition.x = snapThreshold
                
                self.showVerticalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: newPosition.x, y: snapThreshold)
                
            } else if abs(newPosition.x - (geometry.size.width - snapThreshold)) < snapThreshold {
                newPosition.x = geometry.size.width - snapThreshold
                
                self.showVerticalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: newPosition.x, y: snapThreshold)
            }
            
            // Example: Snap to top or bottom edge
            if abs(newPosition.y - snapThreshold) < snapThreshold {
                newPosition.y = snapThreshold
                self.showHorizontalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: snapThreshold)
            } else if abs(newPosition.y - (geometry.size.height - snapThreshold)) < snapThreshold {
                newPosition.y = geometry.size.height - snapThreshold
                self.showHorizontalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: newPosition.y)
            }
            
            // Snap to nearest stroke
            let sectionWidth = geometry.size.width / CGFloat(numberOfSections)
            for i in 1..<numberOfSections {
                let strokePosition = sectionWidth * CGFloat(i)
                if abs(newPosition.x - strokePosition) < snapThreshold {
                    newPosition.x = strokePosition + snapThreshold
                    showVerticalSnapIndicator = true
                    self.snapIndicatorPosition = CGPoint(x: newPosition.x, y: 0)
                    break
                }
            }
            
            // Assign the new position, possibly snapped
            images[index].position = newPosition
        }
    }
    
    func deselectImage(except index: Int) {
        for index in images.indices {
            if index != index {
                images[index].isSelected = false
            }
        }
    }
}
