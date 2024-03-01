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
}
