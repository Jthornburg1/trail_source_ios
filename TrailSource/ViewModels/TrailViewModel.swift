//
//  File.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct TrailViewModel {
    
    var trails: [Trail]?
    var request: URLRequest!
    
    init(with request: URLRequest) {
        self.request = request
    }
    
    func getTrails(completion: @escaping (Bool, Error?) -> ()) {
        let restSession = RESTSession(request: request)
        restSession.asyncRequest { (data, error) in
            guard let trailData = data else {
                DispatchQueue.main.async(execute: {
                    completion(false, error)
                })
            }
            do {
                let trailResponse = try JSONDecoder().decode(TrailApiResponse.self, from: trailData)
                DispatchQueue.main.async(execute: {
                    completion(trailResponse.trails, nil)
                })
            } catch {
                print("unable to decode trails")
            }
        }
    }
}
