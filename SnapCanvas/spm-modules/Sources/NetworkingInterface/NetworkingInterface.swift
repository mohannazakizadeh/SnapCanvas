//
//  NetworkingInterface.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Combine

@available(iOS 13.0, *)
public protocol NetworkingInterface {
    func fetchData<T: Decodable>(with router: NetworkingRouterProtocol, for dataType: T.Type) async throws -> T
}
