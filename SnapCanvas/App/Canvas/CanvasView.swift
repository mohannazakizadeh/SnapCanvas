////
////  CanvasView.swift
////  SnapCanvas
////
////  Created by Mohanna Zakizadeh on 2/25/24.
////
//
//import SwiftUI
//import SwiftUIComponents
//
//struct CanvasView: View {
//    @ObservedObject var viewModel: CanvasViewModel
//    
//    @GestureState private var dragOffset: CGSize = .zero
//    
//    var body: some View {
//        ScrollView(.horizontal) {
//            Spacer()
//            HStack {
//                Canvas { context, size in
//                    let sectionWidth = size.width / CGFloat(viewModel.numberOfSections)
//                    
//                    for index in 1..<viewModel.numberOfSections {
//                        let xPosition = sectionWidth * CGFloat(index)
//                        
//                        // Draw vertical lines to divide the canvas into sections
//                        let path = Path { path in
//                            path.move(to: CGPoint(x: xPosition, y: 0))
//                            path.addLine(to: CGPoint(x: xPosition, y: size.height))
//                        }
//                        context.stroke(path, with: .color(.black), lineWidth: 1)
//                    }
//
//                    for imageModel in viewModel.images {
//                        let image = Image(uiImage: imageModel.image)
//                        let rect = CGRect(origin: imageModel.position, size: imageModel.size)
//                        // Check if this is the active image being dragged
//                        if let activeImage = viewModel.activeDragImage, activeImage.id == imageModel.id {
//                            context.withCGContext { cgContext in
//                                cgContext.setAlpha(0.5) // Reduce opacity for visual feedback
//                                context.draw(image, in: rect)
//                            }
//                        } else {
//                            context.draw(image, in: rect)
//                        }
//                    }
//                    
//                }
//                .accessibilityIdentifier("CanvasViewContainer")
//                .background(Color.white)
//                .frame(width: 150 * CGFloat(viewModel.numberOfSections), height: 200)
//                RoundButton(backgroundColor: Color.gray, foregroundColor: .black, identifier: "AddCanvasButton", imageName: "plus") {
//                    viewModel.addSection()
//                }
//            }
//            .onTapGesture { location in
//                viewModel.selectImage(at: location)
//                print("Debug: item tapped at \(location)")
//            }
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        guard let activeImageID = viewModel.activeDragImage?.id else { return }
//                        let newLocation = CGPoint(x: value.translation.width + (viewModel.activeDragImage?.position.x ?? 0),
//                                                  y: value.translation.height + (viewModel.activeDragImage?.position.y ?? 0))
//                        print("image \(activeImageID) is being dragged")
////                        viewModel.moveImage(id: activeImageID, newPosition: newLocation)
//                    }
//            )
//            Spacer()
//        }
//    }
//}
//
//#Preview {
//    return CanvasView(viewModel: CanvasViewModel(numberOfSections: 3, images: .constant([])))
//}
