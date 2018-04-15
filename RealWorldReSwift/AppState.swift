//
//  AppState.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation
import ReSwift

struct AppState: StateType {

    let places: Loadable<[Place]>
    let lastKnownLocation: CLLocation?
    let authorizationStatus: CLAuthorizationStatus
}
