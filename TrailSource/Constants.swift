//
//  Constants.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/29/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation

struct Constants {
    
    public static let googleKey = "AIzaSyAnZCCdKFXkKMIseBNdRyA84pZAZg_lP3k"
    public static let trailsDebugKey = "7137887-e393547d6311cdca70e38f8564e8701b"
    public static let requestHeaderKey = "key"
    
    public struct endpoints {
        public static let trailsByCoordinate = "https://www.mtbproject.com/data/get-trails"
        public static let coordinateQuery = "?lat=%@&lon=%@&key=\(Constants.trailsDebugKey)"
    }
    
    public struct cellReuseIdsAndNibNames {
        public static let trailCell = "TrailCell"
    }
}
