//
//  SimpleMiddlewareTests.swift
//  RealWorldReSwiftTests
//
//  Created by Tobias Ottenweller on 01.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import XCTest
import Nimble
import ReSwift

@testable import RealWorldReSwift

class SimpleMiddlewareTests: XCTestCase {

    struct State: StateType, Equatable {
        let value: String
    }

    enum Actions: Action {
        case one
        case two
        case three
    }

    let state = State(value: "test")
    var suppliedContext: MiddlewareContext<State>?
    var forwaredAction: Action?
    var dispatchedAction: Action?

    override func setUp() {
        let simpleMiddleware: SimpleMiddleware<State> = { (action, context) in
            self.suppliedContext = context
            context.dispatch(Actions.three)
            return Actions.two
        }

        let middleware = createMiddleware(simpleMiddleware)

        let dispatch = middleware({ self.dispatchedAction = $0 }, { self.state })
        let next = dispatch { self.forwaredAction = $0 }
        next(Actions.one)

        super.setUp()
    }

    override func tearDown() {
        suppliedContext = nil
        forwaredAction = nil
        dispatchedAction = nil
        super.tearDown()
    }


    func testSuppliesState() {
        expect(self.suppliedContext?.state) == state
    }

    func testSuppliesNext() {
        expect(self.forwaredAction as? Actions) == .two
    }

    func testSuppliesDispatch() {
        expect(self.dispatchedAction as? Actions) == .three
    }
}
