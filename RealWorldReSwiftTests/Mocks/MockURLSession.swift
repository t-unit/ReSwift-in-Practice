//
//  MockURLSession.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {

    let mockTask = MockSessionDataTask()
    private(set) var receivedRequest: URLRequest?

    var data: Data?
    var response: URLResponse?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        receivedRequest = request
        completionHandler(data, response, error)
        return mockTask
    }
}

class MockSessionDataTask: URLSessionDataTask {

    private(set) var resumeCalled = false

    override func resume() {
        resumeCalled = true
    }
}
