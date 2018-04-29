//
//  AppReducer.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    return AppState(
        places: placesReducer(action: action, places: state?.places),
        lastKnownLocation: lastKnownLocationReducer(action: action, lastKnownLocation: state?.lastKnownLocation),
        authorizationStatus: authorizationStatusReducer(action: action, authorizationStatus: state?.authorizationStatus)
    )
}

private func placesReducer(action: Action, places: Loadable<[Place]>?) -> Loadable<[Place]> {

    guard
        let placesAction = action as? PlacesAction,
        case .set(let state) = placesAction
    else {
        return places ?? .initial
    }
    return state
}

private func lastKnownLocationReducer(action: Action, lastKnownLocation: CLLocation?) -> CLLocation? {

    guard let action = action as? SetLocationAction else {
        return lastKnownLocation
    }
    return action.location
}

private func authorizationStatusReducer(action: Action, authorizationStatus: CLAuthorizationStatus?) -> CLAuthorizationStatus {

    guard let action = action as? SetAuthorizationStatusAction else {
        return authorizationStatus ?? .notDetermined
    }
    return action.authorizationStatus
}
