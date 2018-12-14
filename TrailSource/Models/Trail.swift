//
//  Trail.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/31/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct TrailApiResponse: Decodable {
    
    let trails: [Trail]
    
}

struct Trail: Decodable {
    
    let id: Int?
    let location: String?
    let latitude: Double
    let longitude: Double
    let name: String
    let difficulty: String?
    let starVotes: Int?
    let thumbnail: String?
    let high: Int?
    let low: Int?
    let stars: Int?
    let length: Int?
    let ascent: Int?
    let descent: Int?
    let url: String?
    let summary: String?
    let type: String?
}
