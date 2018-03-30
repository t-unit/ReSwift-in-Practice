//
//  NetworkFetcherTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import Nimble

@testable import RealWorldReSwift

class NetworkFetcherTests: XCTestCase {

    var sut: NetworkFetcher!
    var mockSession: MockURLSession!

    let request = URLRequest(url: URL(string: "localhost")!)
    let jsonData = try! JSONEncoder().encode(["abc"])
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = NetworkFetcher(session: mockSession, decoder: JSONDecoder())
    }
    
    override func tearDown() {
        mockSession = nil
        sut = nil
        super.tearDown()
    }
    
    func testSuppliesRequest() {
        sut.fetch(request: request) { (result: Result<String>) in }
        expect(self.mockSession.receivedRequest?.url) == request.url
    }

    func testResumes() {
        sut.fetch(request: request) { (result: Result<String>) in }
        expect(self.mockSession.mockTask.resumeCalled) == true
    }

    func testHandlesResponseError() {
        mockSession.error = NSError(domain: "", code: 0, userInfo: nil)
        var error: Error?

        sut.fetch(request: request) { (result: Result<String>) in
            error = result.error
        }
        expect(error as? NetworkFetcherError).toEventually(equal(.response))
    }

    func testParsesCorrectData() {
        mockSession.data = jsonData
        var value: [String]?

        sut.fetch(request: request) { (result: Result<[String]>) in
            value = result.value
        }
        expect(value).toEventually(equal(["abc"]))
    }

    func testHandlesContentError() {
        mockSession.data = jsonData
        var error: Error?

        sut.fetch(request: request) { (result: Result<[Int]>) in
            error = result.error
        }
        expect(error as? NetworkFetcherError).toEventually(equal(.content))
    }
}


