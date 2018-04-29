//
//  MiddlewareTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 08.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import CoreLocation
import Nimble
import ReSwift

@testable import RealWorldReSwift

class BaseMiddlewareTests: XCTestCase {

    let location = CLLocation(latitude: 52.520008, longitude: 13.404954)

    var context: MiddlewareContext<AppState>!
    var state: AppState!
    var dispatchedAction: Action?
    var sut: SimpleMiddleware<AppState>!

    override func setUp() {

        super.setUp()

        state = AppState(
            places: .initial,
            lastKnownLocation: location,
            authorizationStatus: .notDetermined
        )

        context = MiddlewareContext(
            dispatch: { self.dispatchedAction = $0 },
            getState: { self.state },
            next: { _ in }
        )
    }

    override func tearDown() {

        context = nil
        dispatchedAction = nil
        sut = nil
        super.tearDown()
    }

}

class FetchPlacesMiddlewareTests: BaseMiddlewareTests {

    var fakeService: FakePlacesService!

    override func setUp() {

        super.setUp()
        fakeService = FakePlacesService()
        sut = fetchPlaces(service: fakeService)
    }

    override func tearDown() {

        fakeService = nil
        super.tearDown()
    }

    func testReturnsLoadAction() {

        let action = sut(PlacesAction.fetch, context)

        if case .set(let loadable)? = (action as? PlacesAction) {

            if case .loading = loadable {
                // success
            } else {
                XCTFail("Expected .loading got \(loadable)")
            }

        } else {
            XCTFail("Expected .set got \(action.debugDescription)")
        }
    }

    func testSuppliesRadius() {

        _ = sut(PlacesAction.fetch, context)
        expect(self.fakeService.receivedRadius) == 2000.0
    }

    func testSuppliesCoordinates() {

        _ = sut(PlacesAction.fetch, context)
        expect(self.fakeService.reveivedCoordinate?.latitude) == location.coordinate.latitude
        expect(self.fakeService.reveivedCoordinate?.longitude) == location.coordinate.longitude
    }

    func testDispatchesPlaces() {

        fakeService.result = .success(PlacesSearchResult(results: [], status: "BLUBB"))
        _ = sut(PlacesAction.fetch, context)

        expect(self.dispatchedAction as? PlacesAction).toEventuallyNot(beNil())
    }
}

class RequestAuthorizationTests: BaseMiddlewareTests {

    var locationManager: FakeLocationManager!

    override func setUp() {

        super.setUp()
        locationManager = FakeLocationManager()
        sut = requestAuthorization(locationManager: locationManager)
    }

    override func tearDown() {

        locationManager = nil
        super.tearDown()
    }

    func testRequestsAuthorization() {

        _ = sut(RequestAuthorizationAction(), context)
        expect(self.locationManager.requestWhenInUseAuthorizationCalled) == true
    }
}

class StartMonitoringTests: BaseMiddlewareTests {

    var locationManager: FakeLocationManager!

    override func setUp() {

        super.setUp()
        locationManager = FakeLocationManager()
        sut = startMonitoring(locationManager: locationManager)
    }

    override func tearDown() {

        locationManager = nil
        super.tearDown()
    }

    func testStartsMonitoringDidBecomeActive() {

        state = AppState(
            places: .initial,
            lastKnownLocation: location,
            authorizationStatus: .authorizedAlways
        )

        _ = sut(ApplicationDidBecomeActiveAction(), context)
        expect(self.locationManager.startMonitoringSignificantLocationChangesCalled) == true
    }

    func testStartsMonitoringSetAuthorizationStatus() {

        _ = sut(SetAuthorizationStatusAction(authorizationStatus: .authorizedAlways), context)
        expect(self.locationManager.startMonitoringSignificantLocationChangesCalled) == true
    }

    func testDoesNothingOnDidBecomeActiveForInvalidSetAuthorizationStatus() {

        _ = sut(ApplicationDidBecomeActiveAction(), context)
        expect(self.locationManager.startMonitoringSignificantLocationChangesCalled) == false
    }

    func testDoesNothingForInvalidSetAuthorizationStatus() {

        _ = sut(SetAuthorizationStatusAction(authorizationStatus: .denied), context)
        expect(self.locationManager.startMonitoringSignificantLocationChangesCalled) == false
    }
}
