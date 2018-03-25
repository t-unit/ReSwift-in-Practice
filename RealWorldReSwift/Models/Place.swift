//
//  Place.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation

struct Place: Codable {

    enum CodingKeys: String, CodingKey {

        case geometry
        case id
        case name
        case priceLevel = "price_level"
        case rating
    }

    let geometry: Geometry
    let id: String
    let name: String
    let priceLevel: PriceLevel?
    let rating: Double
}
