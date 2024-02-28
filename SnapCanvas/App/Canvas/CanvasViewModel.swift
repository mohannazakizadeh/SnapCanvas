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
    @Published var snapIndicatorOrientation: Orientation = .horizontal
    
    enum Orientation {
        case horizontal, vertical
    }
    let snapThreshold: CGFloat = 20
    
    init(numberOfSections: Int, images: Binding<[ImageToAdd]>) {
        self.numberOfSections = numberOfSections
        self._images = images
    }
    
//    func gestureRecognized(at location: CGPoint? = nil, id: UUID) {
//        if let index = images.firstIndex(where: { $0.id == id }) {
//            selectedImageIndex = index
//            if let location = location {
//                images[index].position = location
//            }
//        }
//    }
//    
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
    
    func stopDragging(for id: UUID, location: CGPoint) {
        if let index = getIndex(for: id) {
            images[index].position = location
            print("location at end of drag is \(images[index].position), drag location is : \(location)")
        }
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
                
                self.showHorizontalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: snapThreshold)
                self.snapIndicatorOrientation = .horizontal
                
            } else if abs(newPosition.x - (geometry.size.width - snapThreshold)) < snapThreshold {
                newPosition.x = geometry.size.width - snapThreshold
                
                self.showHorizontalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: snapThreshold)
                self.snapIndicatorOrientation = .horizontal
            }
            
            // Example: Snap to top or bottom edge
            if abs(newPosition.y - snapThreshold) < snapThreshold {
                newPosition.y = snapThreshold
                self.showVerticalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: snapThreshold)
                self.snapIndicatorOrientation = .horizontal
            } else if abs(newPosition.y - (geometry.size.height - snapThreshold)) < snapThreshold {
                newPosition.y = geometry.size.height - snapThreshold
                self.showVerticalSnapIndicator = true
                self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: snapThreshold)
                self.snapIndicatorOrientation = .horizontal
            }
            
            // Snap to nearest stroke
            let sectionWidth = geometry.size.width / CGFloat(numberOfSections)
            for i in 1..<numberOfSections {
                let strokePosition = sectionWidth * CGFloat(i)
                if abs(newPosition.x - strokePosition) < snapThreshold {
                    newPosition.x = strokePosition
//                    self.showSnapIndicator = true
                    self.snapIndicatorPosition = CGPoint(x: geometry.size.width / 2, y: snapThreshold)
                    self.snapIndicatorOrientation = .horizontal
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
