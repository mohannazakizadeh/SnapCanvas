//
//  OverlayModel.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation


// MARK: - OverlayCategory
struct OverlayCategory: Decodable {
    let title: String
    let items: [OverlayModel]
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case title, items
        case thumbnailURL = "thumbnail_url"
    }
}

// MARK: - Overlay
struct OverlayModel: Decodable {
    let id: Int
    let overlayName, createdAt: String
    let categoryID: Int
    let sourceURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case overlayName = "overlay_name"
        case createdAt = "created_at"
        case categoryID = "category_id"
        case sourceURL = "source_url"
    }
}
