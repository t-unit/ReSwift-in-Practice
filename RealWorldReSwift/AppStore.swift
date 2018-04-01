//
//  AppStore.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import ReSwift

typealias AppStore = Store<AppState>

let appStore = AppStore(
    reducer: appReducer,
    state: nil
)
