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

    @IBOutlet private weak var tableView: UITableView!

    private var data: [Place] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        store.subscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        store.dispatch(PlacesAction.fetch)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
}

extension ViewController: StoreSubscriber {

    typealias StoreSubscriberStateType = AppState

    func newState(state: AppState) {

        guard case .value(let places) = state.places else {
            return // just ignoring error and initial to keep the UI simple
        }
        data = places
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
        cell.priceLabel.text = place.priceLevel?.description ?? ""
        cell.latLabel.text = place.geometry.coordinates.latitude.description
        cell.lonLabel.text = place.geometry.coordinates.longitude.description

        return cell
    }
}
