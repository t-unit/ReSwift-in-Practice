//
//  FakeNetworkFetcher.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation

@testable
import RealWorldReSwift

class FakeNetworkFetcher<T>: NetworkFetching {

    private(set) var receivedRequest: URLRequest?
    var result: Result<T> = .failure(NSError(domain: "", code: 0, userInfo: nil))

    func fetch<T>(request: URLRequest, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask where T: Decodable {

        receivedRequest = request
        completion(result as! Result<T>)
        return URLSessionDataTask()
    }
}
