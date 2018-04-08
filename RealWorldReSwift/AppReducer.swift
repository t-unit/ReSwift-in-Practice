//
//  AppReducer.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    if let placesAction = action as? PlacesAction, case .set(let places) = placesAction {
        return AppState(places: places)
    }

    return AppState(places: nil)
}
