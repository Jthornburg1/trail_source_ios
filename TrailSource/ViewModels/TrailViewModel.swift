//
//  File.swift
//  TrailSource
//
//  Created by jonathan thornburg on 9/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

class TrailViewModel {
    
    var trails = [Trail]()
    var lat: Double!
    var long: Double!
    
    init(with lat: Double, long: Double) {
        self.lat = lat; self.long = long
    }
    
    func getTrails(completion: @escaping (Bool, Error?) -> ()) {
        let query = String(format: Constants.endpoints.coordinateQuery, String(describing: lat!), String(describing: long!))
        guard let url = URL(string: Constants.endpoints.trailsByCoordinate + query) else { return completion(false, nil) }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue(Constants.trailsDebugKey, forHTTPHeaderField: Constants.requestHeaderKey)
        URLSession.shared.dataTask(with: request) { [weak self] (data, resposne, error) in
            guard let dta = data else { return completion(false, error) }
            do {
                guard let json = try JSONSerialization.jsonObject(with: dta, options: .mutableLeaves) as? [String:Any] else { return completion(false, error) }
                guard let trails = json["places"] as? [[String:Any]] else { return completion(false,error) }
                self?.trails.removeAll()
                for trail in trails {
                    let newTrail = Trail(dictionary: trail)
                    self?.trails.append(newTrail)
                }
                DispatchQueue.main.async(execute: {
                    print(self!.trails)
                    completion(true, nil)
                })
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }.resume()
    }
    
    func changeCoordinate(lat: Double, long: Double, completion: @escaping (Bool, Error?) -> ()) {
        self.lat = lat; self.long = long
        getTrails { (success, error) in
            DispatchQueue.main.async(execute: {
                completion(success, error)
            })
        }
    }
}
