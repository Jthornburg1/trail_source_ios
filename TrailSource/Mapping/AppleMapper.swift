//
//  AppleMapper.swift
//  TrailSource
//
//  Created by jonathan thornburg on 3/1/19.
//  Copyright © 2019 jonathan thornburg. All rights reserved.
//

import Foundation
import MapKit

struct AppleMapper: MappingProvider {
    func openMapAppWith(coordinate: CLLocationCoordinate2D, and name: String) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
