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

private func fetchPlaces(action: Action, context: MiddlewareContext<AppState>, service: PlacesServing) -> Action? {

    guard
        let placesAction = action as? PlacesAction,
        case .fetch = placesAction
    else {
        return action
    }

    let fakeCoordinates = CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954)
    let radius = 2000.0

    service.search(coordinates: fakeCoordinates, radius: radius) { result in

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

    guard action is RequestAuthorizationAction else {
        return action
    }

    locationManager.requestWhenInUseAuthorization()
    return nil
}
