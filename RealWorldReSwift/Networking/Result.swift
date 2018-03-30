//
//  Result.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import ReSwift

enum Result<T> {
    
    case success(T)
    case failure(Error)

    var error: Error? {

        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }

    var value: T? {

        switch self {
        case .success(let value): return value
        default: return nil
        }
    }
}
