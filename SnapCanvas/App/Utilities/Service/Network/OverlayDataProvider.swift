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

final class AppDataProvider: NetworkingInterface {
    
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
}

final class OverlayDataProvider: OverlayServiceProtocol {
    func loadOverlays() async throws -> [OverlayCategory] {
        let overlayRouter = OverlayServiceRouter()
        let overLayCategoryData = try await AppDataProvider().fetchData(with: overlayRouter, for: [OverlayCategory].self)
        return overLayCategoryData
    }
    
    func extractAllSourceURLs() async throws -> [String] {
        let categories = try await loadOverlays()
        let allURLs = categories.flatMap { $0.items.map { $0.sourceURL } }
        return allURLs
    }
}
 
