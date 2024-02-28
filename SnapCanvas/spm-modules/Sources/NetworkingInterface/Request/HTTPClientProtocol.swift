//
//  HTTPClientProtocol.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Combine
import Foundation

public protocol HTTPClientProtocol: AnyObject {
    var baseURL: URL { get set }
}

