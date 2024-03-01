//
//  OverlayCollectionViewRepresentable.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import Foundation
import SwiftUI

struct OverlayCollectionViewRepresentable: UIViewControllerRepresentable {
    
    var imageToAddModel: ImagesToAddModel
    var onRequestDismiss: (() -> Void)?
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let dataProvider = OverlayDataProvider()
        let viewModel = OverlaysViewModel(dataProvider: dataProvider, imageToAdd: imageToAddModel)
        viewModel.onRequestDismiss = onRequestDismiss
        
        let navigationController = UINavigationController(rootViewController: OverlayCollectionViewController(overlaysViewModel: viewModel))
        return navigationController
    }
    
}
