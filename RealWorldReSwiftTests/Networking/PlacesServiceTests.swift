//
//  PlacesServiceTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import Nimble
import CoreLocation

@testable import RealWorldReSwift

class PlacesServiceTests: XCTestCase {

    let coordinate = CLLocationCoordinate2D(latitude: 50.44, longitude: 10.123)

    var sut: PlacesService!
    var fakeNetworkFetcher: FakeNetworkFetcher<PlacesSearchResult>!
    var query: String!
    
    override func setUp() {
        super.setUp()
        fakeNetworkFetcher = FakeNetworkFetcher()
        sut = PlacesService(
            locale: Locale(identifier: "en"),
            apiKey: "asdf-qwerty",
            fetcher: fakeNetworkFetcher
        )

        sut.search(
            coordinate: coordinate,
            radius: 200,
            completion: { _ in }
        )

        query = fakeNetworkFetcher.receivedRequest?.url?.query
    }
    
    override func tearDown() {
        sut = nil
        fakeNetworkFetcher = nil
        query = nil
        super.tearDown()
    }

    func testSuppliesStaticQueryParamters() {
        expect(self.query).to(contain("opennow=1"))
        expect(self.query).to(contain("type=restaurant"))
    }

    func testSuppliesBaseURL() {
        let urlString = fakeNetworkFetcher.receivedRequest?.url?.absoluteString
        expect(urlString).to(beginWith("https://maps.googleapis.com/maps/api/place/nearbysearch/json"))
    }

    func testSuppliesCoordinates() {
        expect(self.query).to(contain("location=50.44,10.123"))
    }

    func testSuppliesLocal() {
        expect(self.query).to(contain("language=en"))
    }

    func testSuppliesRadius() {
        expect(self.query).to(contain("radius=200.0"))
    }

    func testSuppliesApiKey() {
        expect(self.query).to(contain("key=asdf-qwerty"))
    }

    func testHandlesErrors() {

        let error = NSError(domain: "", code: 0, userInfo: nil)
        fakeNetworkFetcher.result = .failure(error)
        var result: Result<PlacesSearchResult>?

        sut.search(coordinate: coordinate, radius: 0) {
            result = $0
        }

        expect(result).toEventuallyNot(beNil())

        if case .failure(let receivedError)? = result {
            expect(receivedError as NSError) === error
        } else {
            XCTFail("expected .failure got \(result.debugDescription)")
        }
    }

    func testHandlesSuccess() {

        let value = PlacesSearchResult(results: [], status: "OK")
        fakeNetworkFetcher.result = .success(value)
        var result: Result<PlacesSearchResult>?

        sut.search(coordinate: coordinate, radius: 0) {
            result = $0
        }

        expect(result).toEventuallyNot(beNil())

        if case .success? = result {
            // success
        } else {
            XCTFail("expected .success got \(result.debugDescription)")
        }
    }

    func testHandlesInvalidStatus() {

        let value = PlacesSearchResult(results: [], status: "INVALID")
        fakeNetworkFetcher.result = .success(value)
        var result: Result<PlacesSearchResult>?

        sut.search(coordinate: coordinate, radius: 0) {
            result = $0
        }

        expect(result).toEventuallyNot(beNil())

        if case .failure(let error)? = result {
            let placesError = error as? PlacesSearchResultError
            expect(placesError?.status) == "INVALID"
        } else {
            XCTFail("expected .failure got \(result.debugDescription)")
        }
    }
}
