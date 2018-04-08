//
//  PlacesService.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//


import Foundation
import CoreLocation

protocol PlacesServing {

    func search(coordinates: CLLocationCoordinate2D, radius: Double, completion: @escaping (Result<PlacesSearchResult>) -> Void)
}

struct PlacesService: PlacesServing {

    let locale: Locale
    let apiKey: String
    let fetcher: NetworkFetching

    func search(coordinates: CLLocationCoordinate2D, radius: Double, completion: @escaping (Result<PlacesSearchResult>) -> Void) {

        do {
            let request = try RequestBuilder.build(
                forCoordinates: coordinates,
                radius: radius,
                locale: locale,
                apiKey: apiKey
            )
            fetcher.fetch(request: request) { (result: Result<PlacesSearchResult>) in

                switch result {
                case .failure:
                    completion(result)
                case .success(let searchResult):

                    if searchResult.status == "OK" {
                        completion(.success(searchResult))
                    } else {
                        let error = PlacesSearchResultError(status: searchResult.status)
                        completion(.failure(error))
                    }
                }

            }
        } catch {
            completion(Result.failure(error))
        }
    }
}

private struct RequestBuilder {

    static let baseUrlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

    static func build(forCoordinates coordinates: CLLocationCoordinate2D, radius: Double, locale: Locale, apiKey: String) throws -> URLRequest {

        guard var components = URLComponents(string: baseUrlString) else {
            throw NetworkFetcherError.url
        }

        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "location", value: "\(coordinates.latitude),\(coordinates.longitude)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "language", value: locale.languageCode),
            URLQueryItem(name: "opennow", value: "1"),
            URLQueryItem(name: "type", value: "restaurant")
        ]

        guard let url = components.url else {
            throw NetworkFetcherError.url
        }

        return URLRequest(url: url)
    }
}
