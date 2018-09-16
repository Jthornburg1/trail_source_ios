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
        
        let restSession = RESTSession(request: buildRequest())
        restSession.asyncRequest { [weak self] (data, error) in
            guard let trailData = data else {
                DispatchQueue.main.async(execute: {
                    completion(false, error)
                })
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: trailData, options: .mutableLeaves) as? [String:Any]
                print(String(describing: json!))
                let trailResponse = try JSONDecoder().decode(TrailApiResponse.self, from: trailData)
                self?.trails.removeAll()
                if let places = trailResponse.places {
                    self?.trails = places
                }
                DispatchQueue.main.async(execute: {
                    completion(true, nil)
                })
            } catch {
                print("unable to decode trails")
                print(error.localizedDescription)
            }
        }
    }
    
    func buildRequest() -> URLRequest {
        let apiKeyHeader: HTTPHeaders = [Constants.requestHeaderKey:Constants.trailsDebugKey]
        let baseString = Constants.endpoints.trailsByCoordinate
        let latitude = String(describing: lat!)
        let longitude = String(describing: long!)
        print(latitude)
        print(longitude)
        let coordinateQuery = String(format: Constants.endpoints.coordinateQuery, latitude, longitude)
        print(baseString + coordinateQuery)
        guard let encodedQuery = coordinateQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return URLRequest(url: URL(string: "")!) }
        let requestFactory = RequestFactory(httpMethod: .get, baseURL: URL(string: baseString)!, encodedQueryString: encodedQuery, httpHeaders: apiKeyHeader)
        return requestFactory.buildRequest()
    }
    
    func newCoordinates(lat: Double, long: Double, completion: @escaping (Bool, Error?) -> ()) {
        self.lat = lat; self.long = long
        getTrails { (success, error) in
            DispatchQueue.main.async(execute: {
                completion(success,error)
            })
        }
    }
}
