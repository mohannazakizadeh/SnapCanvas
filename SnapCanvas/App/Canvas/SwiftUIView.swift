//
//  SwiftUIView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/27/24.
//

import SwiftUI
import SwiftUIComponents

struct SwiftUIView: View {
    @ObservedObject var viewModel: CanvasViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Spacer()
            HStack {
                CustomStrokeView(viewModel: viewModel)
                    .background(Color.white)
                    .accessibilityIdentifier("CanvasViewContainer")
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ gesture in
                                viewModel.tapGestureRecognized(at: gesture.predictedEndLocation)
                            })
                    )
                RoundButton(backgroundColor: Color.gray, foregroundColor: .black, identifier: "AddCanvasButton", imageName: "plus") {
                    viewModel.addSection()
                }
            }
            .frame(width: 150 * CGFloat(viewModel.numberOfSections), height: 200)
            Spacer()
        }
    }
}

struct CustomStrokeView: View {
    @ObservedObject var viewModel: CanvasViewModel
    var body: some View {
        
        GeometryReader { geometry in
            let sectionWidth = geometry.size.width / CGFloat(viewModel.numberOfSections)
            
            ZStack {
                
                // Adding images to the view
                ForEach(0..<viewModel.images.count, id: \.self) { index in
                    CustomImageView(
                        imageModel: $viewModel.images[index],
                        parentViewModel: viewModel, 
                        geometry: geometry,
                        didSelectAction: {
                        viewModel.deselectImage(except: index)
                    })
                    .onAppear {
                        viewModel.images[index].position = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
                
                //Add Strokes to view
                ForEach(1..<viewModel.numberOfSections, id: \.self) { index in
                    let xPosition = sectionWidth * CGFloat(index)
                    Path { path in
                        // Start point of the stroke
                        let start = CGPoint(x: xPosition, y: 0)
                        // End point of the stroke
                        let end = CGPoint(x: xPosition, y: geometry.size.height)
                        
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    .stroke(Color.black, lineWidth: 1)
                }
                
//                if viewModel.showHorizontalSnapIndicator {
                    Path { path in
                        let start = CGPoint(x: viewModel.snapIndicatorPosition.x, y: 0)
                        let end = CGPoint(x: viewModel.snapIndicatorPosition.x, y: geometry.size.height)
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    .stroke(Color.yellow, lineWidth: 1)
//                }
            }
        }
        .clipped()
    }
    
    @ViewBuilder
    private func snapIndicator() -> some View {
        let isHorizontal = viewModel.snapIndicatorOrientation == .horizontal
        Path { path in
            let start = isHorizontal ? CGPoint(x: 0, y: viewModel.snapIndicatorPosition.y) : CGPoint(x: viewModel.snapIndicatorPosition.x, y: 0)
            let end = isHorizontal ? CGPoint(x: UIScreen.main.bounds.width, y: viewModel.snapIndicatorPosition.y) : CGPoint(x: viewModel.snapIndicatorPosition.x, y: UIScreen.main.bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(Color.yellow, lineWidth: 2)
    }
}

#Preview {
    SwiftUIView(viewModel: CanvasViewModel(numberOfSections: 3, images: .constant([ImageToAdd(image: UIImage(systemName: "fleuron")!, position: .zero, size: CGSize(width: 60, height: 50))])))
}
