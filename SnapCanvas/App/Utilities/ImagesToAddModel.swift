//
//  ImagesToAddModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import SwiftUI

final class ImagesToAddModel: ObservableObject {
    @Published var images: [ImageToAdd] = []
    
}

final class ImageToAdd: Equatable, ObservableObject {
    
    let id = UUID()
    var image: UIImage
    @Published var position: CGPoint
    var size: CGSize
    @Published var isSelected: Bool
    
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
