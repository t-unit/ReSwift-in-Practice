//
//  Actions.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 30.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation
import CoreLocation
import ReSwift

struct SetPlacesAction: Action {
    let places: PlacesSearchResult
}

func fetchPlaces(state: AppState, store: AppStore) -> Action? {

    let service = PlacesService(
        locale: .current,
        apiKey: "<key here>",
        fetcher: NetworkFetcher(session: .shared, decoder: JSONDecoder())
    )

    let fakeCoordinates = CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954)
    let radius = 2000.0

    service.search(coordinates: fakeCoordinates, radius: radius) { result in
        guard let places = result.value else {
            return
        }

        DispatchQueue.main.async {
            store.dispatch(SetPlacesAction(places: places))
        }
    }

    return nil
}
