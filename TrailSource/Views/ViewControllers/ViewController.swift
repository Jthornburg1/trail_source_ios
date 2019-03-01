//
//  ViewController.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/29/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit
import GooglePlaces
import SVProgressHUD

class ViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var locationManager = CLLocationManager()
    var resultView: UITextView?
    var currentLocation: CLLocation?
    var trailViewModel: TrailViewModel?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        setUpLocationManager()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
        
        tableView.tableFooterView = UIView()
        
        let cellNib = UINib(nibName: Constants.cellReuseIdsAndNibNames.trailCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.cellReuseIdsAndNibNames.trailCell)
        
        searchController?.searchBar.delegate = self
    }
}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        guard let viewModel = trailViewModel else { return }
        searchController?.searchBar.text = place.name
        SVProgressHUD.show(withStatus: "Loading...")
        resultsController.dismiss(animated: true)
        viewModel.changeCoordinate(lat: place.coordinate.latitude, long: place.coordinate.longitude) { (success, error) in
            if success {
                self.locationManager.stopUpdatingLocation()
                SVProgressHUD.dismiss(completion: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setUpLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if currentLocation == nil {
                currentLocation = location
                trailViewModel = TrailViewModel(with: currentLocation!.coordinate.latitude, long: currentLocation!.coordinate.longitude)
                SVProgressHUD.show(withStatus: "Loading...")
                trailViewModel?.getTrails(completion: { (success, error) in
                    if success {
                        SVProgressHUD.dismiss(completion: {
                            self.tableView.reloadData()
                            self.locationManager.stopUpdatingLocation()
                        })
                    }
                })
                
            }
            let latDifference = currentLocation!.coordinate.latitude - location.coordinate.latitude
            let longDifference = currentLocation!.coordinate.longitude - location.coordinate.longitude
            if latDifference > 0.001 || longDifference > 0.001 {
                currentLocation = location
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            presentNoAuthAlert()
        }
    }
    
    func presentNoAuthAlert() {
        let alert = UIAlertController(title: "Status Changed", message: "In order to present trails nearest to you, you must authorize location services when in use for this app in your phone's settings.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func presentMappingAction(to trail: Trail?) {

        guard let trail = trail else { return }
        let actionSheet = UIAlertController(title: NSLocalizedString("Map to trailhead?", comment: ""), message: NSLocalizedString("Which mapping app do you prefer?", comment: ""), preferredStyle: .actionSheet)

        let appleAction = UIAlertAction(title: "Apple Maps", style: .default) { (_) in
            let appleProvider = AppleMapper()
            self.mapTo(trail: trail, with: appleProvider)
        }
        let googleAction = UIAlertAction(title: "Google Maps", style: .default) { (_) in
            let googleProvider = GoogleMapper()
            self.mapTo(trail: trail, with: googleProvider)
        }
        actionSheet.addAction(appleAction)
        actionSheet.addAction(googleAction)
        present(actionSheet, animated: true)
    }

    func mapTo(trail: Trail, with provider: MappingProvider) {
        let coordinate = CLLocationCoordinate2D(latitude: trail.latitude, longitude: trail.longitude)
        let name: String = trail.name
        provider.openMapAppWith(coordinate: coordinate, and: name)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SVProgressHUD.dismiss()
        guard let viewModel = trailViewModel else { return 0 }
        return viewModel.trails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdsAndNibNames.trailCell) as? TrailCell else { return UITableViewCell() }
        guard let viewModel = trailViewModel else { return UITableViewCell() }
        cell.trailNameLabel.text = viewModel.trails[indexPath.row].name
        cell.cityLabel.text = viewModel.trails[indexPath.row].location
        if let currentLocation = currentLocation {
            cell.distanceLabel.text = String(format: "%@ mi.", viewModel.getDistanceFromTrail(at: indexPath.row, with: (currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentMappingAction(to: trailViewModel?.trails[indexPath.row])
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentLocation = nil
        locationManager.startUpdatingLocation()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            if let viewModel = trailViewModel {
                viewModel.clearTrailArray()
                tableView.reloadData()
            }
        }
    }
}

