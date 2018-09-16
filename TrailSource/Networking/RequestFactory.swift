//
//  RequestFactory.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import CoreLocation

typealias HTTPHeaders = [String:String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct RequestFactory {
    
    var httpMethod: HTTPMethod!
    var baseURL: URL!
    var encodedURLQueryString: String?
    var headers: HTTPHeaders?
    
    init(httpMethod: HTTPMethod, baseURL: URL, encodedQueryString: String?, httpHeaders: HTTPHeaders?) {
        self.httpMethod = httpMethod
        self.baseURL = baseURL
        self.encodedURLQueryString = encodedQueryString
        self.headers = httpHeaders
    }
    
    func buildRequest() -> URLRequest {
        var url = baseURL
        if let query = encodedURLQueryString {
            url = url!.appendingPathComponent(query)
        }
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        if let headers = headers {
            for (k,v) in headers {
                request.setValue(v, forHTTPHeaderField: k)
            }
        }
        return request
    }
}
