//
//  LocationObserver.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 29.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation
import ReSwift

class LocationObserver {

    private let store: AppStore

    init(store: AppStore) {

        self.store = store

        store.subscribe(self) { subcription in
            subcription.select { state in state.lastKnownLocation }
        }
    }

    deinit {
        store.unsubscribe(self)
    }
}

extension LocationObserver: StoreSubscriber {

    typealias StoreSubscriberStateType = CLLocation?

    func newState(state: CLLocation?) {

        guard state != nil else {
            return
        }
        store.dispatch(PlacesAction.fetch)
    }
}
