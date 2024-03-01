//
//  AddContentSheetViewModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/24/24.
//

import SwiftUI
import Combine

class AddContentSheetViewModel: ObservableObject {
    
    @Binding var activeSheet: ActiveSheet?
    
    init(activeSheet: Binding<ActiveSheet?>) {
        self._activeSheet = activeSheet
    }
    
    let buttonsInfo = [
        ("photo", "Image"),
        ("play.circle.fill", "Video"),
        ("theatermasks.fill", "GIF"),
        ("sparkles", "Overlay"),
        ("scribble", "Drawing")
    ]
    
    func OverlayButtonTapped() {
        activeSheet = .overLaysBottomSheet
    }
}
