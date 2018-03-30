//
//  AppReducer.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    if let setPlaces = action as? SetPlacesAction {
        return AppState(places: setPlaces.places)
    }

    return AppState(places: nil)
}
