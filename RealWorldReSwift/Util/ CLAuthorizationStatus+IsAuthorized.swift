//
//   CLAuthorizationStatus+IsAuthorized.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 29.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation

extension CLAuthorizationStatus {

    var isAuthorized: Bool {

        guard self == .authorizedAlways || self == .authorizedWhenInUse else {
            return false
        }
        return true
    }
}
