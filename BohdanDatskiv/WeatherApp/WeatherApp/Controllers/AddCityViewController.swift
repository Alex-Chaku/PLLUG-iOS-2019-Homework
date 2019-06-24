//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/10/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit


var cities = [CityData]()

//----------------------------------------
// MARK: - AddCityViewController
//----------------------------------------
class AddCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchedCities = [CityData]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isSearching = false
    @IBOutlet weak var searchCity: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cities.isEmpty {
            self.activityIndicator.startAnimating()
            DispatchQueue.main.async {
                let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cities", ofType: "json")!))
                cities = try! JSONDecoder().decode([CityData].self, from: data!)
                cities.sort {$0.name > $1.name}
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        searchCity.showsCancelButton = true
        searchCity.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchCity.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedCities.count
        } else {
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddCityTableViewCell
        if isSearching {
            cell.cityNameLabel.text = searchedCities[indexPath.row].name
            
        } else {
            cell.cityNameLabel.text = cities[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesWeather") as! CitiesViewController
        if isSearching {
            dvc.addLocationId(searchedCities[indexPath.row].id)
        } else {
            dvc.addLocationId(cities[indexPath.row].id)
        }
        self.present(dvc, animated: true, completion: nil)
    }
}

extension AddCityViewController: UISearchBarDelegate {
    func searchCities(_ text: String) {
        if text == "" {
            searchedCities = cities
        } else {
            searchedCities = cities.filter({$0.name.lowercased().contains(text.lowercased())})
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchCities(searchText)
        isSearching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesWeather") as! CitiesViewController
        self.present(dvc, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            if let cancelButton = searchBar.cancelButton {
                cancelButton.isEnabled = true
                cancelButton.isUserInteractionEnabled = true
            }
        }
    }
}

extension UISearchBar {
    var cancelButton: UIButton? {
        for subView1 in subviews {
            for subView2 in subView1.subviews {
                if let cancelButton = subView2 as? UIButton {
                    return cancelButton
                }
            }
        }
        return nil
    }
}

