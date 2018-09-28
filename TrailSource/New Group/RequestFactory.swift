//
//  RequestFactory.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/27/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

public typealias Parameters = [HeaderKeys:String]

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum HeaderKeys: String {
    case xMashapeKey = "X-Mashape-Key"
    case contentType = "Content-Type"
}

struct RequestFactory {
    
    public static func createRequest(url: URL, method: RequestMethod, parameters: Parameters?) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = method.rawValue
        if let parameters = parameters {
            for (k,v) in parameters {
                request.addValue(v, forHTTPHeaderField: k.rawValue)
            }
        }
        return request
    }
}
