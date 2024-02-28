//
//  BottomSheetView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/24/24.
//

import SwiftUI
import SwiftUIComponents

struct BottomSheetView: View {

    @ObservedObject var viewModel: BottomSheetViewModel
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            HStack {
                ForEach(viewModel.buttonsInfo, id: \.0) { item in
                    BottomSheetButtonView(imageName: item.0, label: item.1, action: {
                        viewModel.OverlayButtonTapped()
                    })
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct BottomSheetButtonView: View {
    var imageName: String
    var label: String
    var action: () -> Void
    var body: some View {
        VStack {
            RoundButton(backgroundColor: Color.gray.opacity(0.5), foregroundColor: .white, identifier: "", imageName: imageName, action: action)
            Text(label)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    BottomSheetView(viewModel: BottomSheetViewModel(showBottomSheet: .constant(false), showOverlays: .constant(false)))
}
