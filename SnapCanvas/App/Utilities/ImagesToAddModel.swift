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
}
