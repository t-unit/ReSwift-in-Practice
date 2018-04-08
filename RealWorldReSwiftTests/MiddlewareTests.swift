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

class MiddlewareTests: XCTestCase {

    var fakeService: FakePlacesService!
    var context: MiddlewareContext<AppState>!
    var dispatchedAction: Action?
    var sut: SimpleMiddleware<AppState>!

    override func setUp() {

        super.setUp()
        fakeService = FakePlacesService()
        context = MiddlewareContext(
            dispatch: { self.dispatchedAction = $0 },
            getState: { nil },
            next: { _ in }
        )
        sut = fetchPlaces(service: fakeService)
    }

    override func tearDown() {

        fakeService = nil
        context = nil
        dispatchedAction = nil
        sut = nil
        super.tearDown()
    }


    func testReturnsNoAction() {

        let action = sut(PlacesAction.fetch, context)
        expect(action).to(beNil())
    }

    func testSuppliesRadius() {

        _ = sut(PlacesAction.fetch, context)
        expect(self.fakeService.receivedRadius) == 2000.0
    }

    func testSuppliesCoordinates() {

        _ = sut(PlacesAction.fetch, context)
        expect(self.fakeService.reveivedCoordinates?.latitude) == 52.520008
        expect(self.fakeService.reveivedCoordinates?.longitude) == 13.404954
    }

    func testDispatchesPlaces() {

        fakeService.result = .success(PlacesSearchResult(results: [], status: "BLUBB"))
        _ = sut(PlacesAction.fetch, context)

        expect(self.dispatchedAction as? PlacesAction).toEventuallyNot(beNil())
    }

    func testIgnoresErrors() {

        fakeService.result = .failure(NSError(domain: "", code: 0, userInfo: nil))
        _ = sut(PlacesAction.fetch, context)

        expect(self.dispatchedAction as? PlacesAction).toEventually(beNil())
    }
}
