//
//  PriceLevel.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation

enum PriceLevel: Int, Codable {

    case free = 0
    case cheap = 1
    case moderat = 2
    case expensive = 3
    case veryExpensive = 4
}
