//
//  HTTPMethod.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

public enum HTTPMethod: String, Equatable {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

