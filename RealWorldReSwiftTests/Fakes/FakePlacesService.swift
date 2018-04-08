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
    private(set) var reveivedCoordinates: CLLocationCoordinate2D?

    var result: Result<PlacesSearchResult>?

    func search(coordinates: CLLocationCoordinate2D, radius: Double, completion: @escaping (Result<PlacesSearchResult>) -> Void) {

        reveivedCoordinates = coordinates
        receivedRadius = radius

        if let result = result {
            completion(result)
        }
    }
}
