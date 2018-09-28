//
//  AppSession.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/17/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct AppSession {
    
    var request: URLRequest!
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func sendRequest(handler: @escaping (Data?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                handler(data, error)
            })
        }.resume()
        
    }
}

