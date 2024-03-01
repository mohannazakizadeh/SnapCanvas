//
//  ImagesToAddModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Observation
import Foundation
import UIKit

@Observable
final class ImagesToAddModel {
    var images: [ImageToAdd] = []
    
}

@Observable
final class ImageToAdd: Equatable {
    
    let id = UUID()
    var image: UIImage
    var position: CGPoint
    var size: CGSize
    var isSelected: Bool
    
    init(image: UIImage, position: CGPoint, size: CGSize, isSelected: Bool = false) {
        self.image = image
        self.position = position
        self.size = size
        self.isSelected = isSelected
    }
    
    static func == (lhs: ImageToAdd, rhs: ImageToAdd) -> Bool {
        lhs.id == rhs.id
    }
}
