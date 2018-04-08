//
//  CLLocationCoordinate2DTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 08.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import CoreLocation
import Nimble

@testable
import RealWorldReSwift

class CLLocationCoordinate2DTests: XCTestCase {

    let data = try! JSONSerialization.data(
        withJSONObject: ["lng": 12.0, "lat": 99.0],
        options: []
    )
    
    func testEncode() {

        let sut = CLLocationCoordinate2D(latitude: 77, longitude: 32)
        let data = try? JSONEncoder().encode(sut)
        let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])
        let dict = json as? [String: Any]

        expect(dict?["lng"] as? Double) == 32
        expect(dict?["lat"] as? Double) == 77
    }

    func testDecode() {

        let sut = try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: data)

        expect(sut?.longitude) == 12.0
        expect(sut?.latitude) == 99.0
    }
}
