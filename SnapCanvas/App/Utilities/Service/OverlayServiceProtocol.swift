//
//  OverlayServiceProtocol.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation

protocol OverlayServiceProtocol {
    func loadOverlays() async throws -> [OverlayCategory]
    func extractAllSourceURLs() async throws -> [String]
}
