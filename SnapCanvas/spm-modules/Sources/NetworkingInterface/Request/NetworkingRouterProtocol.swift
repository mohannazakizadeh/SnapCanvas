//
//  NetworkingRouterProtocol.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation

public protocol NetworkingRouterProtocol {
    var method: HTTPMethod { get }
    var path: String { get }
}
