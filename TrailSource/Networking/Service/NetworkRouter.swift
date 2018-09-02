//
//  NetworkRouter.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/1/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLRequest?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndpointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
