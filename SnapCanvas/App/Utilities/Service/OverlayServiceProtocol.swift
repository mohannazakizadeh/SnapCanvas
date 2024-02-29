//
//  OverlayServiceProtocol.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation
import UIKit

protocol OverlayServiceProtocol {
    func loadOverlays() async throws -> [OverlayCategory]
    func extractAllSourceURLs() async throws -> [String]
    func fetchImage(with url: URL?) async throws -> UIImage?
}
