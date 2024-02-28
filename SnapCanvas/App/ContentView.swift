//
//  ContentView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/23/24.
//

import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    
    @State var showSheet = false
    @State var showOverlays = false
    @StateObject var imagesToAdd: ImagesToAddModel = ImagesToAddModel()
    
    var body: some View {
        VStack {
            SwiftUIView(viewModel: CanvasViewModel(numberOfSections: 3, images: $imagesToAdd.images))
            
            RoundButton(backgroundColor: Color.white, foregroundColor: .black, identifier: "ShowSheetButton", imageName: "plus") {
                showSheet = true
            }
        }
        .sheet(isPresented: $showSheet, content: {
            BottomSheetView(viewModel: BottomSheetViewModel(showBottomSheet: $showSheet, showOverlays: $showOverlays))
                .presentationDetents([.height(150)])
        })
        
        .sheet(isPresented: $showOverlays, content: {
            OverlayCollectionViewRepresentable(imageToAddModel: imagesToAdd) {
                showOverlays = false
            }
        })
        
        .background(Color.black)
    }
}

#Preview {
    ContentView()
}
