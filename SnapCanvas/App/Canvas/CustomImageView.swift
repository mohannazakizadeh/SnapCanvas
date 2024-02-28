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
                imageModel.position = newLocation
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? imageModel.position
            }
    }
    
    private var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
            .onChanged { gesture in
                
                // Check proximity to edges
                parentViewModel.snapDragging(for: imageModel.id, location: gesture.location, geometry: geometry)
//                let closeToLeftOrRight = position.width < edgeThreshold || (geometry.size.width - (position.width + geometry.size.width / 2)) < edgeThreshold
//                let closeToTopOrBottom = position.height < edgeThreshold || (geometry.size.height - (position.height + geometry.size.height / 2)) < edgeThreshold
//                
//                shouldShowSnapLines = closeToLeftOrRight || closeToTopOrBottom
            }
    }
    
    var body: some View {
        Image(uiImage: imageModel.image)
            .resizable()
            .scaledToFit()
            .border(imageModel.isSelected ? Color.blue : Color.clear, width: 2)
            .position(imageModel.position)
            .rotationEffect(imageModel.angle)
            .gesture(
                simpleDrag.simultaneously(with: fingerDrag)
            )
            .simultaneousGesture(
                RotationGesture()
                    .onChanged({ angle in
                        imageModel.angle = angle
                    })
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
                .task {
                    /// Moving item to center after adding
                    mock.position = CGPoint(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                }
        }
    }
    }
