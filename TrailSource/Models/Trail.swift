//
//  Trail.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/31/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct TrailApiResponse {
    let numberOfResults: Int
    let trails: [Trail]
}

extension TrailApiResponse: Decodable {
    
    private enum TrailApiResponseCodingKeys: String, CodingKey {
        case numberOfResults = "results"
        case trails = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TrailApiResponseCodingKeys.self)
        
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        trails = try container.decode([Trail].self, forKey: .trails)
    }
}

struct Trail {
    
    var id: Int
    var city: String?
    var region: String?
    var lat: Double
    var long: Double
    var name: String
    var difficulty: String?
    var rating: Double?
    var thumbnail: String?
    
}

extension Trail: Decodable {
    
    enum TrailCodingKeys: String, CodingKey {
        case id = "id"
        case city = "city"
        case region = "region"
        case lat = "lat"
        case long = "long"
        case name = "name"
        case difficulty = "difficulty"
        case rating = "rating"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let trailContainer = try decoder.container(keyedBy: TrailCodingKeys.self)
        
        id = try trailContainer.decode(Int.self, forKey: .id)
        city = try trailContainer.decode(String.self, forKey: .city)
        region = try trailContainer.decode(String.self, forKey: .region)
        lat = try trailContainer.decode(Double.self, forKey: .lat)
        long = try trailContainer.decode(Double.self, forKey: .long)
        name = try trailContainer.decode(String.self, forKey: .name)
        difficulty = try trailContainer.decode(String.self, forKey: .difficulty)
        rating = try trailContainer.decode(Double.self, forKey: .rating)
        thumbnail = try trailContainer.decode(String.self, forKey: .thumbnail)
        
    }
}
