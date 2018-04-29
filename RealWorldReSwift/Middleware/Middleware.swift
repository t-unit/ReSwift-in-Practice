//
//  Middleware.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 01.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import ReSwift
import CoreLocation

typealias Middleware = SimpleMiddleware<AppState>

func fetchPlaces(service: PlacesServing) -> Middleware {
    return { fetchPlaces(action: $0, context: $1, service: service) }
}

func requestAuthorization(locationManager: LocationManager) -> Middleware {
    return { requestAuthorization(action: $0, context: $1, locationManager: locationManager) }
}

func startMonitoring(locationManager: LocationManager) -> Middleware {
    return { startMonitoring(action: $0, context: $1, locationManager: locationManager) }
}

private func fetchPlaces(action: Action, context: MiddlewareContext<AppState>, service: PlacesServing) -> Action? {

    guard
        let placesAction = action as? PlacesAction,
        case .fetch = placesAction
    else {
        return action
    }

    guard let coordinate = context.state?.lastKnownLocation?.coordinate else {
        return PlacesAction.set(Loadable.error(NoCoordinateError()))
    }

    service.search(coordinate: coordinate, radius: 2000.0) { result in

        DispatchQueue.main.async {
            let state: Loadable<[Place]>

            switch result {
            case .failure(let error): state = .error(error)
            case .success(let value): state = .value(value.results)
            }

            context.dispatch(PlacesAction.set(state))
        }
    }

    return PlacesAction.set(.loading)
}

private func requestAuthorization(action: Action, context: MiddlewareContext<AppState>, locationManager: LocationManager) -> Action? {

    if action is RequestAuthorizationAction {
        locationManager.requestWhenInUseAuthorization()
    }

    return action
}

private func startMonitoring(action: Action, context: MiddlewareContext<AppState>, locationManager: LocationManager) -> Action? {

    let appDidBecomeActive = action is ApplicationDidBecomeActiveAction
    let isAuthorized = context.state?.authorizationStatus.isAuthorized == true
    let setAuthorizationStatusAction = action as? SetAuthorizationStatusAction
    let isSetAuthorized = setAuthorizationStatusAction?.authorizationStatus.isAuthorized == true

    if (appDidBecomeActive && isAuthorized) || (isSetAuthorized && !isAuthorized) {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestLocation()
    }

    return action
}

private struct NoCoordinateError: Error {}

