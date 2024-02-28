//
//  ImagesToAddModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import SwiftUI
import Combine

final class ImagesToAddModel: ObservableObject {
    @Published var images: [ImageToAdd] = []
}

struct ImageToAdd: Equatable {
    let id = UUID()
    var image: UIImage
    var position: CGPoint
    var size: CGSize
    var isSelected: Bool = false
    var angle: Angle = Angle()
    
//    init(image: UIImage, position: CGPoint, size: CGSize, isSelected: Bool) {
//        self.image = image
//        self.position = position
//        self.size = size
//        self.isSelected = isSelected
//    }
//    
//    static func == (lhs: ImageToAdd, rhs: ImageToAdd) -> Bool {
//        lhs.id == rhs.id
//    }
}
