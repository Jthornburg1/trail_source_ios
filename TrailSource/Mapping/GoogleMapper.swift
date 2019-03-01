//
//  GoogleMapper.swift
//  TrailSource
//
//  Created by jonathan thornburg on 3/1/19.
//  Copyright © 2019 jonathan thornburg. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

struct GoogleMapper: MappingProvider {
    func openMapAppWith(coordinate: CLLocationCoordinate2D, and name: String) {
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving") {
            UIApplication.shared.open(url, options: [:])
        } else {
            print("Not able to use google maps for this coordinate")
        }
    }
}
