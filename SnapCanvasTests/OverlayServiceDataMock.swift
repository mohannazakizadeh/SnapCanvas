//
//  OverlayServiceDataMock.swift
//  SnapCanvasTests
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import Foundation
@testable import SnapCanvas
import UIKit
import NetworkingInterface
import Networking

final class OverlayServiceDataMock: OverlayServiceProtocol {
    
    enum MockError: Error {
        case mockLoadError
    }
    
    private func loadMockedData() throws -> [OverlayCategory] {
        guard let fileUrl = Bundle.main.url(forResource: "OverlayMockData", withExtension: "json") else {
            throw MockError.mockLoadError
        }
        
        let jsonData = try Data(contentsOf: fileUrl)
        let overlayData = try JSONDecoder().decode([OverlayCategory].self, from: jsonData)
        
        return overlayData
    }
    
    func loadOverlays() async throws -> [OverlayCategory] {
        return try loadMockedData()
    }
    
    func extractAllSourceURLs() async throws -> [String] {
        let categories = try await loadOverlays()
        let allURLs = categories.flatMap { $0.items.map { $0.sourceURL } }
        return allURLs
    }
    
    func fetchImage(with url: URL?) async throws -> UIImage? {
        let client = HTTPClient(baseURL: URL(fileURLWithPath: ""))
        let request = HTTPRequest(router: OverlayServiceRouter())
        request.url = url
        
        do {
            let response = try await request.fetch(client)
            if let data = response.data {
                return UIImage(data: data)
            }
        }
        catch let error as HTTPResponseError {
            throw error
        }
        return nil
    }
}
