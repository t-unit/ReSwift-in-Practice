//
//  NetworkFetcher.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import Foundation

enum NetworkFetcherError: Error {

    case url
    case response
    case content
}

struct NetworkFetcher {

    let session: URLSession
    let decoder: JSONDecoder

    init(session: URLSession, decoder: JSONDecoder) {

        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func fetch<T>(request: URLRequest, completion: @escaping (Result<T>) -> Void) throws -> URLSessionDataTask where T: Decodable {

        let task = session.dataTask(with: request) { (optionalData, response, error) in
            
            guard let data = optionalData, error == nil else {
                completion(.failure(NetworkFetcherError.response))
                return
            }

            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkFetcherError.content))
            }
        }

        task.resume()
        return task
    }
}
