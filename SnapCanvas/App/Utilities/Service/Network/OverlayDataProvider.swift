//
//  OverlayDataProvider.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation
import NetworkingInterface
import Combine
import Networking
import UIKit

final class OverlayDataProvider: NetworkingInterface ,OverlayServiceProtocol {
    
    static let baseURL: URL = URL(string: "https://appostropheanalytics.herokuapp.com")!
    
    private let networkLogger: HTTPLoggerProtocol
    
    init(logger: HTTPLoggerProtocol = NetworkLogger.shared) {
        self.networkLogger = logger
    }
    
    func fetchData<T>(with router: NetworkingRouterProtocol, for dataType: T.Type) async throws -> T where T : Decodable {
        let client = HTTPClient(baseURL: Self.baseURL, networkLogger: networkLogger)
        let request = HTTPRequest(router: router)
        
        do {
            let response = try await request.fetch(client).decode(dataType.self)
            return response
        }
        catch let error as HTTPResponseError {
            throw error
        }
    }
    
    func fetchImage(with url: URL?) async throws -> UIImage? {
        let client = HTTPClient(baseURL: Self.baseURL)
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
    
    func loadOverlays() async throws -> [OverlayCategory] {
        let overlayRouter = OverlayServiceRouter()
        let overLayCategoryData = try await fetchData(with: overlayRouter, for: [OverlayCategory].self)
        return overLayCategoryData
    }
    
    func extractAllSourceURLs() async throws -> [String] {
        let categories = try await loadOverlays()
        let allURLs = categories.flatMap { $0.items.map { $0.sourceURL } }
        return allURLs
    }
}
 
