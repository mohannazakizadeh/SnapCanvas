//
//  AddContentSheetView.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/24/24.
//

import SwiftUI
import SwiftUIComponents

struct AddContentSheetView: View {

    var viewModel: AddContentSheetViewModel
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
        .accessibilityElement(children: .ignore)
        .ignoresSafeArea()
    }
}

private extension AddContentSheetView {
    
    struct BottomSheetButtonView: View {
        
        var imageName: String
        var label: String
        var action: () -> Void
        var body: some View {
            VStack {
                RoundButton(backgroundColor: Color.gray.opacity(0.5), foregroundColor: .white, identifier: imageName, imageName: imageName, action: action)
                Text(label)
                    .foregroundStyle(.white)
                    .accessibilityIdentifier(label)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityIdentifier(label + imageName)
        }
    }
}

#Preview {
    AddContentSheetView(viewModel: AddContentSheetViewModel(activeSheet: .constant(.addContentBottomSheet)))
}
