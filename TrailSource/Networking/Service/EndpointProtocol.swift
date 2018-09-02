//
//  EndpointProtocol.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/1/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

protocol EndpointType {
    var baseURL: String { get }
    var pathString: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var httpHeaders: HTTPHeaders? { get }
}



