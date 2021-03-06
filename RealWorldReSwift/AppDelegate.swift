//
//  AppDelegate.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import CoreLocation
import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let placesService: PlacesServing
    private let appStore: AppStore
    private let locationEmitter: LocationEmitter
    private let locationObserver: LocationObserver

    override init() {

        let locationManager = CLLocationManager()

        placesService = PlacesService(
            locale: .current,
            apiKey: "<key here>",
            fetcher: NetworkFetcher(session: .shared, decoder: JSONDecoder())
        )

        appStore = AppStore(
            reducer: appReducer,
            state: nil,
            middleware: [
                createMiddleware(fetchPlaces(service: placesService)),
                createMiddleware(requestAuthorization(locationManager: locationManager)),
                createMiddleware(startMonitoring(locationManager: locationManager))
            ]
        )

        locationEmitter = LocationEmitter(locationManager: locationManager, store: appStore)
        locationObserver = LocationObserver(store: appStore)

        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let viewController = window?.rootViewController as! ViewController
        viewController.store = appStore

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appStore.dispatch(ApplicationDidBecomeActiveAction())
    }
}
