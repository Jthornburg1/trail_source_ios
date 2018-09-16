//
//  Trail.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/31/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct TrailApiResponse: Decodable {
    let places: [Trail]?
}

struct Trail: Decodable {
    
    let id: Int
    let city: String?
    let region: String?
    let lat: Double
    let long: Double
    let name: String
    let difficulty: String?
    let rating: Double?
    let thumbnail: String?
    
}
