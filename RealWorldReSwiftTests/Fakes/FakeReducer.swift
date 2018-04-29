//
//  FakeReducer.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 29.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation
import ReSwift

@testable import RealWorldReSwift

class FakeReducer {

    var actions: [Action]! = []

    var places: Loadable<[Place]> = .initial
    var lastKnownLocation: CLLocation? = nil
    var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse

    func reduce(action: Action, state: AppState?) -> AppState {

        actions.append(action)
        return AppState(
            places: places,
            lastKnownLocation: lastKnownLocation,
            authorizationStatus: authorizationStatus
        )
    }
}
