//
//  PlacesSearchResult.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation

struct PlacesSearchResult: Decodable {

    let results: [Place]
    let status: String
}
