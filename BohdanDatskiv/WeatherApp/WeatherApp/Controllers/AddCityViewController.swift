//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/10/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - AddCityViewController
//----------------------------------------
class AddCityViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchCity: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cities: Geocoding?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        activityIndicator.hidesWhenStopped = true
        
        searchCity.showsCancelButton = true
        searchCity.delegate = self
        searchCity.enablesReturnKeyAutomatically = true
        searchCity.becomeFirstResponder()
    }
}

extension AddCityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = cities else { return 0 }
        return cities.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddCityTableViewCell
        guard let cities = cities else {
            return cell
        }
        cell.cityNameLabel.text = cities.results[indexPath.row].formattedAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesWeather") as! CitiesViewController
        guard let cities = cities else { return }
        let newCityLocation = cities.results[indexPath.row].geometry.location
        let newCityCoordinate = Coordinate(lon: newCityLocation.lng, lat: newCityLocation.lat)
        do {
            try dvc.addCityCoordinate(newCityCoordinate)
        } catch {
            print(error)
        }
        self.present(dvc, animated: true, completion: nil)
    }
}

extension AddCityViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cities = nil
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesWeather") as! CitiesViewController
        self.present(dvc, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        activityIndicator.startAnimating()
        NetworkManager.shared.getCoordinateForLocation(name: searchText) { (geocoding, error) in
            self.cities = geocoding
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
