//
//  ViewController.swift
//  TrailSource
//
//  Created by jonathan thornburg on 8/29/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var locationManager = CLLocationManager()
    var resultView: UITextView?
    var isSearchingByGoogleQuery = false
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
        getTrails { (success, error) in
            
        }
    }
    
    func getTrails(completion: @escaping (Bool, Error?) -> ()) {
        let session = URLSession.shared
        guard let url = URL(string: "https://trailapi-trailapi.p.mashape.com/?lat=37.9864932173393&lon=-78.507843337968") else {return}
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.addValue(Constants.trailsDebugKey, forHTTPHeaderField: Constants.requestHeaderKey)
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, response, err) in
            do {
                let apiResponse = try JSONDecoder().decode(TrailApiResponse.self, from: data!)
                if let trails = apiResponse.places {
                    print(trails)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            print(response)
            print(err?.localizedDescription)
            completion(true,err)
        }.resume()
    }

}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        trailViewModel?.newCoordinates(lat: place.coordinate.latitude, long: place.coordinate.longitude, completion: { (success, error) in
            
        })
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
                trailViewModel?.getTrails(completion: { (success, error) in
                    if success {
                        print(self.trailViewModel!.trails.count)
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

