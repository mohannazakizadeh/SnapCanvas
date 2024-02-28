//
//  BottomSheetViewModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/24/24.
//

import SwiftUI
import Combine

class BottomSheetViewModel: ObservableObject {
    
    @Binding var showBottomSheet: Bool
    @Binding var showOverlays: Bool
    
    init(showBottomSheet: Binding<Bool>, showOverlays: Binding<Bool>) {
        self._showBottomSheet = showBottomSheet
        self._showOverlays = showOverlays
    }
    
    let buttonsInfo = [
        ("photo", "Image"),
        ("play.circle.fill", "Video"),
        ("theatermasks.fill", "GIF"),
        ("sparkles", "Overlay"),
        ("scribble", "Drawing")
    ]
    
    func OverlayButtonTapped() {
        showBottomSheet = false
        showOverlays = true
    }
}
