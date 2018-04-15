//
//  AppReducerTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 08.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation
import XCTest
import ReSwift
import Nimble

@testable
import RealWorldReSwift

// MARK: - places
class AppReducerPlacesTests: XCTestCase {
    
    func testSetsIntial() {

        let state = appReducer(action: FakeAction(), state: nil)

        if case .inital = state.places {
            // success
        } else {
            XCTFail("Expected .inital got \(state.places)")
        }
    }

    func testSetsSuccesResult() {

        let state = appReducer(action: PlacesAction.set(.value([])), state: nil)

        if case .value = state.places {
            // sucess
        } else {
            XCTFail("Expected .value got \(state.places)")
        }
    }

    func testSetsFailureResult() {

        let error = NSError(domain: "", code: 0, userInfo: nil)
        let state = appReducer(action: PlacesAction.set(.error(error)), state: nil)

        if case .error = state.places {
            // sucess
        } else {
            XCTFail("Expected .error got \(state.places)")
        }
    }
}

// MARK: - last known location
class AppReducerLastKnownLocationTests: XCTestCase {

    func testKeepsNil() {

        let state = appReducer(action: FakeAction(), state: nil)
        expect(state.lastKnownLocation).to(beNil())
    }

    func testUpdates() {

        let location = CLLocation(latitude: 23, longitude: -23)
        let state = appReducer(action: SetLocationAction(location: location), state: nil)

        expect(state.lastKnownLocation) == location
    }
}

// MARK: - authorizationStatus
class AppReducerAuthorizationStatusTests: XCTestCase {

    func testSetsInitialValue() {

        let state = appReducer(action: FakeAction(), state: nil)
        expect(state.authorizationStatus) == .notDetermined
    }

    func testUpdates() {

        let status: CLAuthorizationStatus = .authorizedAlways
        let state = appReducer(action: SetAuthorizationStatusAction(authorizationStatus: status), state: nil)
        expect(state.authorizationStatus) == status
    }
}

private struct FakeAction: Action { }
