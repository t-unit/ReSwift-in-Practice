//
//  ViewController.swift
//  RealWorldReSwift
//
//  Created by Tobias Ottenweller on 25.03.18.
//  Copyright © 2018 Tobias Ottenweller. All rights reserved.
//

import UIKit
import ReSwift

class ViewController: UIViewController {

    var store: AppStore!

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var authorizationNotDeterminedView: UIView!
    @IBOutlet private var authorizationDeniedView: UIView!

    private var data: [Place] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    @IBAction private func requestAuthorizationButtonTouchUpInside(_ sender: Any) {
        store.dispatch(RequestAuthorizationAction())
    }
}

extension ViewController: StoreSubscriber {

    typealias StoreSubscriberStateType = AppState

    func newState(state: AppState) {

        if case .value(let places) = state.places {
            data = places
        }

        authorizationNotDeterminedView.isHidden = state.authorizationStatus != .notDetermined
        authorizationDeniedView.isHidden = state.authorizationStatus.isAuthorized
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "place", for: indexPath) as! PlaceTableViewCell
        let place = data[indexPath.row]

        cell.nameLabel.text = place.name
        cell.ratingLabel.text = place.rating.description
        cell.priceLabel.text = price(forLevel: place.priceLevel)
        cell.latLabel.text = place.geometry.coordinate.latitude.description
        cell.lonLabel.text = place.geometry.coordinate.longitude.description

        return cell
    }

    private func price(forLevel priceLevel: PriceLevel?) -> String {

        switch priceLevel {
        case .free?: return "free"
        case .cheap?: return "cheap"
        case .moderat?: return "moderat"
        case .expensive?: return "expensive"
        case .veryExpensive?: return "very expensive"
        default: return ""
        }
    }
}
