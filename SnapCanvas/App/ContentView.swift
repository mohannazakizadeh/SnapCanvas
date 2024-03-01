//
//  ContentView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/23/24.
//

import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    
    @State var activeSheet: ActiveSheet?
    var imagesToAdd: ImagesToAddModel = ImagesToAddModel()
    
    var body: some View {
        VStack {
            ScrollingCanvasView(viewModel: CanvasViewModel(numberOfSections: 3, images: imagesToAdd.images))
            
            RoundButton(backgroundColor: Color.white, foregroundColor: .black, identifier: "ShowSheetButton", imageName: "plus") {
                activeSheet = .addContentBottomSheet
            }
        }
        .sheet(item: $activeSheet, content: { sheet in
            switch sheet {
            case .addContentBottomSheet:
                AddContentSheetView(viewModel: AddContentSheetViewModel(activeSheet: $activeSheet))
                    .presentationDetents([.height(150)])
                    .accessibilityIdentifier("AddContentSheetView")
                    .accessibilityElement(children: .ignore)
            case .overLaysBottomSheet:
                OverlayCollectionViewRepresentable(imageToAddModel: imagesToAdd) {
                    activeSheet = nil
                }
            }
        })
        .background(Color.black)
    }
}

enum ActiveSheet: Identifiable {
    case addContentBottomSheet
    case overLaysBottomSheet
    
    // This computed property provides a unique ID for each case
    var id: Int {
        switch self {
        case .addContentBottomSheet:
            return 0
        case .overLaysBottomSheet:
            return 1
        }
    }
}

#Preview {
    ContentView()
}
