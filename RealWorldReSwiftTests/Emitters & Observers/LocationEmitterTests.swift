//
//  LocationEmitterTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 15.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import CoreLocation
import Nimble
import ReSwift

@testable import RealWorldReSwift

class LocationEmitterTests: XCTestCase {

    var locationManager: FakeLocationManager!
    var store: AppStore!
    var reducer: FakeReducer!
    var sut: LocationEmitter!

    let initial = CLLocation(latitude: 0, longitude: 0)

    override func setUp() {

        super.setUp()
        locationManager = FakeLocationManager()
        locationManager.location = initial
        locationManager.authorizationStatus = .restricted
        reducer = FakeReducer()
        store = AppStore(reducer: reducer.reduce, state: nil)
        sut = LocationEmitter(locationManager: locationManager, store: store)
    }

    override func tearDown() {

        locationManager = nil
        store = nil
        sut = nil
        reducer = nil
        super.tearDown()
    }

    func testSetsDelegate() {
        expect(self.locationManager.delegate) === sut
    }

    func testDispatchesInitialAuthorizationEvent() {

        let action = reducer.actions.first(where: { $0 is SetAuthorizationStatusAction }) as? SetAuthorizationStatusAction
        expect(action?.authorizationStatus) == .restricted
    }

    func testDispatchesAuthorizationEvent() {

        sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)

        let action = reducer.actions.last as? SetAuthorizationStatusAction
        expect(action?.authorizationStatus) == .authorizedWhenInUse
    }

    func testDispatchesInitialLocationEvent() {

        let action = reducer.actions.first(where: { $0 is SetLocationAction }) as? SetLocationAction
        expect(action?.location) == initial
    }

    func testDispatchesLocationEvent() {

        let location = CLLocation(latitude: 50, longitude: 50)
        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

        let action = reducer.actions.last as? SetLocationAction
        expect(action?.location) == location
    }
}
