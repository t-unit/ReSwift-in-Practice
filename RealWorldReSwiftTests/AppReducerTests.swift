//
//  AppReducerTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 08.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import ReSwift
import Nimble

@testable
import RealWorldReSwift

class AppReducerTests: XCTestCase {
    
    func testSetsIntialPlace() {

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

private struct FakeAction: Action { }
