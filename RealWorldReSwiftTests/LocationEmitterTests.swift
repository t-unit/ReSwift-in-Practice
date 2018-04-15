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
    var actions: [Action]! = []
    var sut: LocationEmitter!

    let inital = CLLocation(latitude: 0, longitude: 0)

    override func setUp() {

        super.setUp()
        locationManager = FakeLocationManager()
        locationManager.location = inital
        locationManager.authorizationStatus = .restricted
        store = AppStore(reducer: reducer, state: nil)
        actions = []
        sut = LocationEmitter(locationManager: locationManager, store: store)
    }

    override func tearDown() {

        locationManager = nil
        store = nil
        sut = nil
        actions = nil
        super.tearDown()
    }

    func testSetsDelegate() {
        expect(self.locationManager.delegate) === sut
    }

    func testDispatchesInitialAuthorizationEvent() {

        let action = actions.first(where: { $0 is SetAuthorizationStatusAction }) as? SetAuthorizationStatusAction
        expect(action?.authorizationStatus) == .restricted
    }

    func testDispatchesAuthorizationEvent() {

        sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)

        let action = actions.last as? SetAuthorizationStatusAction
        expect(action?.authorizationStatus) == .authorizedWhenInUse
    }

    func testDispatchesInitialLocationEvent() {

        let action = actions.first(where: { $0 is SetLocationAction }) as? SetLocationAction
        expect(action?.location) == inital
    }

    func testDispatchesLocationEvent() {

        let location = CLLocation(latitude: 50, longitude: 50)
        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

        let action = actions.last as? SetLocationAction
        expect(action?.location) == location
    }

    private func reducer(action: Action, state: AppState?) -> AppState {

        actions.append(action)
        return AppState(
            places: .inital,
            lastKnownLocation: nil,
            authorizationStatus: .authorizedWhenInUse
        )
    }
}
