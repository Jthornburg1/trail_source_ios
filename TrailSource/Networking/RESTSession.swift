//
//  RESTSession.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/31/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct RESTSession {
    
    var request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func asyncRequest(handler: @escaping (Data?, Error?) -> ()) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let dta = data else { handler(nil, error); return }
            DispatchQueue.main.async(execute: {
                handler(dta, nil)
            })
        }
        task.resume()
        
    }
}
