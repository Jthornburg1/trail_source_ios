//
//  HTTPTask.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/1/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}
