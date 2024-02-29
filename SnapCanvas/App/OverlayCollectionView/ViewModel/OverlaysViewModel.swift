//
//  OverlaysViewModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation
import Combine
import SwiftUI
import NetworkingInterface


final class OverlaysViewModel {
    var dataProvider: OverlayServiceProtocol
    var overlayCollectionViewDataSource: OverlayCollectionViewDataSource?
    var onRequestDismiss: (() -> Void)?
    @ObservedObject var imagesToAddModel: ImagesToAddModel
    
    init(dataProvider: OverlayServiceProtocol, imageToAdd: ObservedObject<ImagesToAddModel>) {
        self.dataProvider = dataProvider
        self._imagesToAddModel = imageToAdd
    }
    
    func loadOverlays() {
        Task {
            do {
                let overlaysUrl = try await dataProvider.extractAllSourceURLs()
                
                await MainActor.run {
                    self.overlayCollectionViewDataSource?.updateOverlays(with: overlaysUrl)
                }
            } catch let error as HTTPResponseError {
                print("DEBUG: \(error)")
            }
        }
    }
    
    func loadImage(for urlString: String) async throws -> UIImage? {
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//        
//        if let image = UIImage(data: data) {
//            return image
//        } else {
//            throw URLError(.cannotDecodeContentData)
//        }
        
        let image = try await self.dataProvider.fetchImage(with: URL(string: urlString))
        return image
    }
    
    func getSize(for image: UIImage) -> CGSize {
        let maxWidth: CGFloat = 100.0
        let maxHeight: CGFloat = 100.0
        
        // Calculate the scaling factor to maintain the aspect ratio
        let widthScale = maxWidth / CGFloat(image.size.width)
        let heightScale = maxHeight / CGFloat(image.size.height)
        let scale = min(widthScale, heightScale) // Use the smaller scale to ensure it fits within the max bounds
        
        // Calculate the scaled width and height
        let scaledWidth = CGFloat(image.size.width) * scale
        let scaledHeight = CGFloat(image.size.height) * scale
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
}
