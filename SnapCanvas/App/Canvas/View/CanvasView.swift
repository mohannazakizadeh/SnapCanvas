//
//  CanvasView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/28/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    var body: some View {
        
        GeometryReader { geometry in
            let sectionWidth = geometry.size.width / CGFloat(viewModel.numberOfSections)
            
            ZStack() {
                // Adding images to the view
                ForEach(0..<viewModel.images.count, id: \.self) { index in
                    CustomImageView(
                        imageModel: viewModel.images[index],
                        parentViewModel: viewModel,
                        geometry: geometry,
                        didEndDrag: {
                            viewModel.didEndDrag()
                        })
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
                
                // Snap Indicators
                if viewModel.showHorizontalSnapIndicator {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: viewModel.snapIndicatorPosition.y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: viewModel.snapIndicatorPosition.y))
                    }
                    .stroke(Color.yellow, lineWidth: 1)
                }
                
                if viewModel.showVerticalSnapIndicator {
                    Path { path in
                        path.move(to: CGPoint(x: viewModel.snapIndicatorPosition.x, y: 0))
                        path.addLine(to: CGPoint(x: viewModel.snapIndicatorPosition.x, y: geometry.size.height))
                    }
                    .stroke(Color.yellow, lineWidth: 1)
                }
            }
            .contentShape(Rectangle()) // Makes the whole area tappable, not just the HStack
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ gesture in
                        viewModel.tapGestureRecognized(at: gesture.location)
                    })
            )
        }
        .clipped()
    }
}

#Preview {
    CanvasView(viewModel: CanvasViewModel(numberOfSections: 3, images: .constant([])))
}
