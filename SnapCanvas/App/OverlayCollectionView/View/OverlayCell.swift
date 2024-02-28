//
//  OverlayCell.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import UIKit

final class OverlayCell: UICollectionViewCell {
    
    static let identifier = "OverlayCell"
    
    let overlayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(overlayImageView)
        
        NSLayoutConstraint.activate([
            overlayImageView.topAnchor
                .constraint(equalTo: self.contentView.topAnchor),
            overlayImageView.leftAnchor
                .constraint(equalTo: self.contentView.leftAnchor),
            overlayImageView.rightAnchor
                .constraint(equalTo: self.contentView.rightAnchor),
            overlayImageView.bottomAnchor
                .constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        overlayImageView.image = nil
    }
    
    func fetchImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        if let image = UIImage(data: data) {
            return image
        } else {
            throw URLError(.cannotDecodeContentData)
        }
    }
}
