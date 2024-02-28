//
//  CustomImageView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/28/24.
//

import SwiftUI

struct CustomImageView: View {
    @Binding var imageModel: ImageToAdd
    @ObservedObject var parentViewModel: CanvasViewModel
    var geometry: GeometryProxy
    let edgeThreshold: CGFloat = 50.0
    
    var didSelectAction: () -> Void = {}
    
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    private var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? imageModel.position
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                parentViewModel.snapDragging(for: imageModel.id, location: newLocation, geometry: geometry)
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? imageModel.position
            }
    }
    
    var body: some View {
        Image(uiImage: imageModel.image)
            .resizable()
            .scaledToFit()
            .border(imageModel.isSelected ? Color.blue : Color.clear, width: 2)
            .frame(width: imageModel.size.width, height: imageModel.size.height)
            .position(imageModel.position)
            .rotationEffect(imageModel.angle)
            .gesture(
                simpleDrag
            )
            .onTapGesture {
                imageModel.isSelected = true
                didSelectAction()
            }
    }
}

#Preview {
    Preview()
}

struct Preview: View {
    @State private var mock: ImageToAdd = .init(
        image: UIImage(systemName: "fleuron")!,
        position: .zero,
        size: CGSize()
    )
    
    var body: some View {
        GeometryReader { geometry in
            CustomImageView(
                imageModel: $mock,
                parentViewModel: CanvasViewModel(numberOfSections: 3, images: .constant([])),
                geometry: geometry
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