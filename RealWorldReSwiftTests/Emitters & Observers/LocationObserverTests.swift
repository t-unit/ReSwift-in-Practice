//
//  LocationObserverTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 29.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import CoreLocation
import Nimble
import ReSwift

@testable import RealWorldReSwift

class LocationObserverTests: XCTestCase {

    var store: AppStore!
    var reducer: FakeReducer!
    var sut: LocationObserver!

    let initial = CLLocation(latitude: 0, longitude: 0)

    override func setUp() {

        super.setUp()
        reducer = FakeReducer()
        store = AppStore(reducer: reducer.reduce, state: nil)
        sut = LocationObserver(store: store)
    }

    override func tearDown() {

        store = nil
        sut = nil
        reducer = nil
        super.tearDown()
    }

    func testDispatchesActionWithLocation() {

        store.dispatch(FakeAction())

        let placesActions = reducer.actions.filter { $0 is PlacesAction }
        expect(placesActions).to(beEmpty())
    }

    func testDoesNothingWithoutLocation() {

        reducer.lastKnownLocation = CLLocation(latitude: 0, longitude: 0)
        store.dispatch(FakeAction())

        let placesActions = reducer.actions.filter { $0 is PlacesAction }
        expect(placesActions.count) == 1

        switch reducer.actions.last as? PlacesAction {
        case .fetch?: break
        default: XCTFail("Expected .fetch got \(String(describing: reducer.actions.last))")
        }
    }
}
