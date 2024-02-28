//
//  NetworkLogger.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation
import Networking

struct NetworkLogger: HTTPLoggerProtocol {
    
    public static var shared = NetworkLogger()
    
    private init() {}
    
    private var showTimeStamp = true
    private var logHeaders = true
    private var logRequestBody = true
    
    func log(for request: HTTPRequest, response: HTTPResponse?, error: Error?, executionTime: TimeInterval) {
        var message: String = ""
        defer {
            message.append("🏁 Request execution time: \(String(format: "%.2f", executionTime * 1000)) ms 🏁\n")
            message.append("🔺 == End network log response == 🔺\n")
            print(message)
        }
        // Request
        
        message.append("\n🔻 == Start network log request == 🔻\n")
        if showTimeStamp {
            message.append("  == Time: \(dateToString(date: Date()))\n")
        }
        message.append("  == Full request url:\n")
        message.append("\(request.urlRequest?.url?.absoluteString ?? "Empty base url")")
        message.append(" [\(request.method)]\n")
        if let requestHeaders = request.urlRequest?.allHTTPHeaderFields {
            if logHeaders {
                message.append("  == Request headers: == \n[\n")
                for (key,value) in requestHeaders {
                    message.append("    \(key) : \(value)\n")
                }
                message.append("] \n")
            }
        }
        if request.body?.content.isEmpty == false && logRequestBody {
            if let body = request.body {
                message.append(" == Parameters (HTTPBody):\n")
                let httpBodyString: String = String(data: body.content, encoding: .utf8) ?? "BAD ENCODING\n"
                message.append("  \(httpBodyString)\n")
            }
        }
        
        // Response
        guard let response else {
            // If response is nil then error must have value
            message.append("❌ Network request error: ❌ \n")
            if let error {
                message.append(error.localizedDescription)
            } else {
                message.append("Error and response both are nil, logger not working!")
            }
            message.append("\n")
            return
        }
        message.append("  ==  HTTP response status code: \(response.statusCode)\n")
        if let error {
            message.append("❌ Got url request error: ❌\n")
            message.append("\(error.localizedDescription)\n")
        }
        guard let data = response.data else {
            if response.statusCode.responseType == .success {
                message.append("✅ Success response with empty callback data. status code: (\(response.statusCode) ✅")
            } else {
                message.append("❌ Empty data response error: ❌\n")
            }
            return
        }
        if let responseHeaders = response.httpResponse?.allHeaderFields {
            if logHeaders {
                message.append("  ==  HTTP response headers: == \n [ \n")
                for (key,value) in responseHeaders {
                    message.append("    \(key) : \(value)\n")
                }
                message.append(" ] \n")
            }
        }
        message.append("✅ Response data: ✅\n")
        if let decodedJson = data.prettyPrintedJSONString {
            message.append("\(decodedJson)\n")
        } else {
            message.append("  == Data is not valid json, decoding as UTF8:\n")
            let responseDataString: String = String(data: data, encoding: .utf8) ?? "BAD ENCODING\n"
            message.append("\(responseDataString)\n")
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        
        return prettyPrintedString
    }
}
