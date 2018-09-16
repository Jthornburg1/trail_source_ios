//
//  Trail.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/31/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct Trail {
    
    let id: Int
    let city: String?
    let region: String?
    let lat: Double
    let lon: Double
    let name: String
    let difficulty: String?
    let rating: Double?
    let thumbnail: String?
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? -1
        city = dictionary["city"] as? String ?? ""
        region = dictionary["region"] as? String ?? ""
        lat = dictionary["lat"] as? Double ?? -1.0
        lon = dictionary["lon"] as? Double ?? -1.0
        name = dictionary["name"] as? String ?? ""
        difficulty = dictionary["difficulty"] as? String ?? ""
        rating = dictionary["rating"] as? Double ?? -1.0
        thumbnail = dictionary["thumbnail"] as? String ?? ""
    }
    
}
