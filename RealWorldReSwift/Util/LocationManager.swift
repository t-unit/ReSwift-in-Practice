//
//  LocationManager.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 15.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation

protocol LocationManager: class {

    var authorizationStatus: CLAuthorizationStatus { get }
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }

    func requestWhenInUseAuthorization()
    func startMonitoringSignificantLocationChanges()
    func requestLocation()
}

extension CLLocationManager: LocationManager {

    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}
