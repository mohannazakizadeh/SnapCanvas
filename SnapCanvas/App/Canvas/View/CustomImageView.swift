//
//  CustomImageView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/28/24.
//

import SwiftUI

struct CustomImageView: View {
    var imageModel: ImageToAdd
    var parentViewModel: CanvasViewModel
    var geometry: GeometryProxy
    
    var didEndDrag: () -> Void
    
    @GestureState private var startLocation: CGPoint? = nil
    
    private var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? imageModel.position
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                parentViewModel.snapDragging(for: imageModel.id, location: newLocation, geometry: geometry)
                imageModel.isSelected = true
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? imageModel.position
            }
            .onEnded { _ in
                didEndDrag()
            }
    }
    
    var body: some View {
        Image(uiImage: imageModel.image)
            .resizable()
            .scaledToFit()
            .border(imageModel.isSelected ? Color.blue : Color.clear, width: 2)
            .frame(width: imageModel.size.width, height: imageModel.size.height)
            .position(imageModel.position)
            .onTapGesture {
                imageModel.isSelected = true
            }
            .simultaneousGesture(
                simpleDrag
            )
    }
}

#Preview {
    Preview()
}

struct Preview: View {
    @State private var mock: ImageToAdd = .init(
        image: UIImage(systemName: "fleuron")!,
        position: .zero,
        size: CGSize(), isSelected: false
    )
    
    var body: some View {
        GeometryReader { geometry in
            CustomImageView(
                imageModel: mock,
                parentViewModel: CanvasViewModel(numberOfSections: 3, images: []),
                geometry: geometry, didEndDrag: {}
            )
            .onAppear {
                /// Moving item to center after adding
                mock.position = CGPoint(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
            }
        }
    }
}
