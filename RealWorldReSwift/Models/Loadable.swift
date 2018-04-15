//
//  Loadable.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 08.04.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

enum Loadable<T> {

    case inital
    case loading
    case value(T)
    case error(Error)
}
