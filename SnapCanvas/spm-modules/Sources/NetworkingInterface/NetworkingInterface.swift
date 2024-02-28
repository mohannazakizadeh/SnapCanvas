//
//  NetworkingInterface.swift
//  
//
//  Created by Mo Zakizadeh on 2/20/23.
//

import Combine

@available(iOS 13.0, *)
public protocol NetworkingInterface {
    func fetchData<T: Decodable>(with router: NetworkingRouterProtocol, for dataType: T.Type) async throws -> T
}
