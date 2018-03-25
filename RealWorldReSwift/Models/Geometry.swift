//
//  Geometry.swift
//  LunchMate
//
//  Created by Tobias Ottenweller on 31.10.17.
//  Copyright © 2017 Tobias Ottenweller. All rights reserved.
//

import CoreLocation

struct Geometry: Codable {

    enum CodingKeys: String, CodingKey {

        case coordinates = "location"
    }

    let coordinates: CLLocationCoordinate2D
}
