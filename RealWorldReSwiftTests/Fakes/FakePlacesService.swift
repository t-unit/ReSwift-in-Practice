//
//  FakePlacesService.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 08.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation

@testable
import RealWorldReSwift

class FakePlacesService: PlacesServing {

    private(set) var receivedRadius: Double?
    private(set) var reveivedCoordinate: CLLocationCoordinate2D?

    var result: Result<PlacesSearchResult>?

    func search(coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping (Result<PlacesSearchResult>) -> Void) {

        reveivedCoordinate = coordinate
        receivedRadius = radius

        if let result = result {
            completion(result)
        }
    }
}
