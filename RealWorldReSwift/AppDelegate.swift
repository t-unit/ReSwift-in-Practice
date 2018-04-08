//
//  AppDelegate.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let placesService: PlacesServing
    private let appStore: AppStore

    override init() {

        placesService = PlacesService(
            locale: .current,
            apiKey: "<key here>",
            fetcher: NetworkFetcher(session: .shared, decoder: JSONDecoder())
        )

        appStore = AppStore(
            reducer: appReducer,
            state: nil,
            middleware: [
                createMiddleware(fetchPlaces(service: placesService))
            ]
        )

        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let viewController = window?.rootViewController as! ViewController
        viewController.store = appStore

        return true
    }
}
