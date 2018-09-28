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
    
    func getTails(completion: @escaping (Bool, Error?) -> ()) {
        let query = String(format: Constants.endpoints.coordinateQuery, String(describing: lat!), String(describing: long!))
        guard let url = URL(string: Constants.endpoints.trailsByCoordinate + query) else { return completion(false, nil) }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue(Constants.trailsDebugKey, forHTTPHeaderField: Constants.requestHeaderKey)
        URLSession.shared.dataTask(with: request) { [weak self] (data, resposne, error) in
            guard let dta = data else { return completion(false, error) }
            do {
                
                let apiResponse = try JSONDecoder().decode(TrailApiResponse.self, from: dta)
                self?.trails = apiResponse.places
                DispatchQueue.main.async(execute: {
                    completion(true, error)
                })
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func getTrails(completion: @escaping (Bool, Error?) -> ()) {
        let query = String(format: Constants.endpoints.coordinateQuery, String(describing: lat!), String(describing: long!))
        guard let url = URL(string: Constants.endpoints.trailsByCoordinate + query) else { return completion(false, nil) }
        let request = RequestFactory.createRequest(url: url, method: .get, parameters: [.xMashapeKey:Constants.trailsDebugKey])
        let appSession = AppSession(request: request)
        appSession.sendRequest { (data, error) in
            guard let data = data, error == nil else { return completion(false, error) }
            
            do {
                let apiResponse = try JSONDecoder().decode(TrailApiResponse.self, from: data)
                self.trails = apiResponse.places
                DispatchQueue.main.async(execute: {
                    completion(true, nil)
                })
            } catch let decodeError {
                print(decodeError.localizedDescription)
                completion(false, decodeError)
            }
        }
    }
    
    func changeCoordinate(lat: Double, long: Double, completion: @escaping (Bool, Error?) -> ()) {
        self.lat = lat; self.long = long
        getTrails { (success, error) in
            DispatchQueue.main.async(execute: {
                completion(success, error)
            })
        }
    }
    
    func clearTrailArray() {
        trails.removeAll()
    }
}
