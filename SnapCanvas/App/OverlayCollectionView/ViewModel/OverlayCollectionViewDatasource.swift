//
//  OverlayCollectionViewDelegate.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import UIKit

final class OverlayCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Variables
    private(set) var items: [String] = []
    private let collectionView: UICollectionView
    private var viewModel: OverlaysViewModel
    
    private let overlayImagesCache = NSCache<NSNumber, UIImage>()
    
    // MARK: - Initializer
    init(collectionView: UICollectionView, viewModel: OverlaysViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        
        // Register cell to collectionView
        self.collectionView.register(OverlayCell.self, forCellWithReuseIdentifier: OverlayCell.identifier)
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                OverlayCell.identifier, for: indexPath)
                as? OverlayCell else {
            return UICollectionViewCell()
        }
        return cell
    }

    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = overlayImagesCache.object(forKey: NSNumber(value: indexPath.row)) {
            let size = viewModel.getSize(for: image)
            let position = CGPoint(x: size.width / 2, y: size.height / 2)
            let imageToAddModel = ImageToAdd(image: image, position: position, size: size, isSelected: true)
            viewModel.imagesToAddModel.images.append(imageToAddModel)
        }
        viewModel.onRequestDismiss?()
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? OverlayCell else { return }
        let cellNumber = NSNumber(value: indexPath.row)
        let imageURL = items[indexPath.row]
        
        if let cachedImage = self.overlayImagesCache.object(forKey: cellNumber) {
            cell.overlayImageView.image = cachedImage
        } else {
            Task {
                if let image = try? await viewModel.loadImage(for: imageURL) {
                    await MainActor.run {
                        cell.overlayImageView.image = image
                        self.overlayImagesCache.setObject(image, forKey: cellNumber)
                    }
                }
            }
        }
    }
    
    func updateOverlays(with overlaysUrl: [String]) {
        self.items = overlaysUrl
        self.collectionView.reloadData()
    }
    
}
