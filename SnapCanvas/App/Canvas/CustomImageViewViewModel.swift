//
//  CustomImageViewViewModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/28/24.
//

import Foundation
import SwiftUI


final class CustomImageViewViewModel: ObservableObject {
    @Binding var imageModel: ImageToAdd
    var geometry: GeometryProxy
    var parentViewModel: CanvasViewModel
    
    init(imageModel: Binding<ImageToAdd>, parentViewModel: CanvasViewModel, geometry: GeometryProxy) {
        self._imageModel = imageModel
        self.parentViewModel = parentViewModel
        self.geometry = geometry
    }
    
    func snapDragging(location: CGPoint) {
        parentViewModel.snapDragging(for: imageModel.id, location: location, geometry: geometry)
    }
}
