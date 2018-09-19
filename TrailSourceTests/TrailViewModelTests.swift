//
//  TrailViewModelTests.swift
//  TrailSourceTests
//
//  Created by jonathan thornburg on 9/19/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import XCTest
@testable import TrailSource

class TrailViewModelTests: XCTestCase {
    
    var viewModel: TrailViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = TrailViewModel(with: 46.9225738, long: -96.7962515)
        let trail1 = Trail(id: 1, city: "Bismark", region: nil, lat: 46.7225738, lon: -96.7662515, name: "TrailOne", difficulty: "Easy", rating: 4.1, thumbnail: nil, activities: nil)
        let trail2 = Trail(id: 1, city: "Suburb1", region: nil, lat: 46.9825738, lon: -96.7922515, name: "TrailTwo", difficulty: "Hard", rating: 4.8, thumbnail: nil, activities: nil)
        let trail3 = Trail(id: 1, city: "Suburb2", region: nil, lat: 46.2225738, lon: -96.7982515, name: "TrailThree", difficulty: "Moderate", rating: 3.5, thumbnail: nil, activities: nil)
        viewModel!.trails = [trail1, trail2, trail3]
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testDoesClearAllRemoveAllTrails() {
        viewModel?.clearTrailArray()
        XCTAssert(viewModel!.trails.count == 0)
    }
}
