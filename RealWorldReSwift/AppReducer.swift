//
//  AppReducer.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    return AppState(
        places: placesReducer(action: action, places: state?.places)
    )
}

private func placesReducer(action: Action, places: Loadable<[Place]>?) -> Loadable<[Place]> {

    guard
        let placesAction = action as? PlacesAction,
        case .set(let state) = placesAction
    else {
        return places ?? .inital
    }
    return state
}
