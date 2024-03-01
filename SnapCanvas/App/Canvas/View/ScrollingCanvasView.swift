//
//  ScrollingCanvasView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/27/24.
//

import SwiftUI
import SwiftUIComponents

struct ScrollingCanvasView: View {
    var viewModel: CanvasViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Spacer()
            HStack {
                CanvasView(viewModel: viewModel)
                    .background(Color.white)
                    .accessibilityIdentifier("CanvasViewContainer")
                RoundButton(backgroundColor: Color.gray, foregroundColor: .black, identifier: "AddCanvasButton", imageName: "plus") {
                    viewModel.addSection()
                }
            }
            .frame(width: 150 * CGFloat(viewModel.numberOfSections), height: 200)
            Spacer()
        }
    }
}

#Preview {
    ScrollingCanvasView(viewModel: CanvasViewModel(numberOfSections: 3, images: [ImageToAdd(image: UIImage(systemName: "fleuron")!, position: .zero, size: CGSize(width: 60, height: 50), isSelected: false)]))
}
