//
//  AppStore.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 15.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//


import CoreLocation
import ReSwift

final class LocationEmitter: NSObject {
    
    private let locationManager: LocationManager
    private let store: AppStore
    
    init(locationManager: LocationManager, store: AppStore) {
        
        self.locationManager = locationManager
        self.store = store
        super.init()

        locationManager.delegate = self
        dispatch(authorizationStatus: locationManager.authorizationStatus)
        dispatch(location: locationManager.location)
    }

    private func dispatch(authorizationStatus: CLAuthorizationStatus) {

        let action = SetAuthorizationStatusAction(authorizationStatus: authorizationStatus)
        store.dispatch(action)
    }

    private func dispatch(location: CLLocation?) {

        guard let location = location else {
            return
        }

        let action = SetLocationAction(location: location)
        store.dispatch(action)
    }
}

extension LocationEmitter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        dispatch(authorizationStatus: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        dispatch(location: locations.last)
    }
}

protocol LocationManager: class {

    var authorizationStatus: CLAuthorizationStatus { get }
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
}

extension CLLocationManager: LocationManager {

    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}
