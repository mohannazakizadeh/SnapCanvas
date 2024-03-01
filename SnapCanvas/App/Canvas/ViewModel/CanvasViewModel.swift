//
//  CanvasViewModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/23/24.
//

import SwiftUI
import Observation

@Observable
class CanvasViewModel: ObservableObject {
    
    var numberOfSections: Int = 3
    var images: [ImageToAdd]
    var showHorizontalSnapIndicator: Bool = false
    var showVerticalSnapIndicator: Bool = false
    var snapIndicatorPosition: CGPoint = .zero
    
    private let snapThreshold: CGFloat = 5
    
    init(numberOfSections: Int, images: [ImageToAdd]) {
        self.numberOfSections = numberOfSections
        self.images = images
    }
    
    func tapGestureRecognized(at location: CGPoint) {
        if let index = images.firstIndex(where: { imageModel in
            // Calculate the origin based on center and size
            let originX = imageModel.position.x - (imageModel.size.width / 2)
            let originY = imageModel.position.y - (imageModel.size.height / 2)
            
            // Create the frame
            let imageFrame = CGRect(x: originX, y: originY, width: imageModel.size.width, height: imageModel.size.height)
            return imageFrame.contains(location)
        }) {
            images[index].isSelected = true
        } else {
            for index in images.indices {
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
        guard let index = getIndex(for: id) else { return }
        var newPosition = location

        // Snap to left
        if abs(newPosition.x - (images[index].size.width/2) - snapThreshold) < snapThreshold {
            newPosition.x = snapThreshold + (images[index].size.width/2)
            
            self.showVerticalSnapIndicator = true
            self.snapIndicatorPosition = CGPoint(x: snapThreshold, y: 0)
        } 
        // snap to right
        else if abs(newPosition.x + (images[index].size.width/2) - (geometry.size.width - snapThreshold)) < snapThreshold {
            newPosition.x = (geometry.size.width - snapThreshold) - (images[index].size.width/2)
            
            self.showVerticalSnapIndicator = true
            self.snapIndicatorPosition = CGPoint(x: geometry.size.width - snapThreshold, y: 0)
        }
        
        // Snap to top edge
        if abs(newPosition.y - (images[index].size.height/2) - snapThreshold) < snapThreshold {
            newPosition.y = snapThreshold + (images[index].size.height/2)
            self.showHorizontalSnapIndicator = true
            self.snapIndicatorPosition = CGPoint(x: 0, y: snapThreshold)
        }
        // snap to bottom edge
        else if abs(newPosition.y + (images[index].size.height/2) - (geometry.size.height - snapThreshold)) < snapThreshold {
            newPosition.y = (geometry.size.height - snapThreshold) - (images[index].size.height/2)
            self.showHorizontalSnapIndicator = true
            self.snapIndicatorPosition = CGPoint(x: 0, y: (geometry.size.height - snapThreshold))
        }
        
        // Snap to nearest stroke
        let sectionWidth = geometry.size.width / CGFloat(numberOfSections)
        for i in 1..<numberOfSections {
            let strokePosition = sectionWidth * CGFloat(i)
            if abs(newPosition.x - strokePosition) < snapThreshold {
                newPosition.x = strokePosition
                showVerticalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: strokePosition, y: 0)
                break
            }
        }
        
        // snap to middle
        if abs(newPosition.x - (geometry.size.width / 2)) < snapThreshold {
            newPosition.x = geometry.size.width / 2
            showVerticalSnapIndicator = true
            snapIndicatorPosition = CGPoint(x: newPosition.x, y: 0)
        }
        
        if abs(newPosition.y - (geometry.size.height / 2)) < snapThreshold {
            newPosition.y = geometry.size.height / 2
            showHorizontalSnapIndicator = true
            snapIndicatorPosition = CGPoint(x: newPosition.x, y: newPosition.y)
        }
        
        // Assign the new position, possibly snapped
        images[index].position = newPosition
        
    }
    
    func didEndDrag() {
        showVerticalSnapIndicator = false
        showHorizontalSnapIndicator = false
    }
}
