//
//  MappingProvider.swift
//  TrailSource
//
//  Created by jonathan thornburg on 3/1/19.
//  Copyright © 2019 jonathan thornburg. All rights reserved.
//

import Foundation
import CoreLocation

protocol MappingProvider {
    func openMapAppWith(coordinate: CLLocationCoordinate2D, and name: String)
}
