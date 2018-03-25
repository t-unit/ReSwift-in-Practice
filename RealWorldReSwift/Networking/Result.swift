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
}
