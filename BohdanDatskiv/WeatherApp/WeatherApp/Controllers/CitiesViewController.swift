//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/10/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit
import CoreLocation

//----------------------------------------
// MARK: - CitiesViewController
//----------------------------------------
class CitiesViewController: UIViewController {
    
    @IBOutlet weak var farenheitButton: UIButton!
    @IBOutlet weak var celsiusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isTempScaleToggled = [false]
    var citiesCurrentWeather = [CurrentWeather]()
    var citiesCoordinates = [Coordinate]()
    var localWeather: CurrentWeather?
    let locationManager = CLLocationManager()

    private enum Key: String, StorageKey {
        var key: String {
            return self.rawValue
        }
        case coordinates
        case tempScale
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        tableView.isHidden = true
        
        do {
            isTempScaleToggled = try UserDefaultsDataManager.shared.get(key: Key.tempScale)
        } catch {
            print(error)
        }
        do {
            self.citiesCoordinates = try getCitiesCoordinates()
        } catch {
            print(error)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        citiesCoordinates.forEach { (coordinate) in
            NetworkManager.shared.getCityCurrentWeather(coordinate: coordinate) { (weather, error) in
                guard let weather = weather else { return }
                self.citiesCurrentWeather.append(weather)
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addCityButtonTapped(_ sender: UIButton) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCity") as! AddCityViewController
        
        self.present(dvc, animated: true, completion: nil)
    }    
    
    func addCityCoordinate(_ coordinate: Coordinate) throws {
        do {
            self.citiesCoordinates = try getCitiesCoordinates()
        } catch {
            print(error)
        }
        self.citiesCoordinates.append(coordinate)
        try UserDefaultsDataManager.shared.set(value: self.citiesCoordinates, key: Key.coordinates)
    }
    
    func getCitiesCoordinates() throws -> [Coordinate] {
        return try UserDefaultsDataManager.shared.get(key: Key.coordinates) as [Coordinate]
    }
    
    func removeCityCoordinate(at index: Int) throws {
        citiesCoordinates.remove(at: index)
        try UserDefaultsDataManager.shared.set(value: citiesCoordinates, key: Key.coordinates)
    }
    
    @IBAction func celsiusButtonTapped(_ sender: UIButton) {
        toggleTempScale()
    }
    
    @IBAction func farenheitButtonTapped(_ sender: UIButton) {
        toggleTempScale()
    }
    
    func toggleTempScale() {
        celsiusButton.isEnabled = !celsiusButton.isEnabled
        farenheitButton.isEnabled = !farenheitButton.isEnabled
        isTempScaleToggled[0] = !isTempScaleToggled.first!
        do {
            try UserDefaultsDataManager.shared.set(value: isTempScaleToggled, key: Key.tempScale)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesCurrentWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        cell.cityNameLabel.text = citiesCurrentWeather[indexPath.row].name
        let temp = isTempScaleToggled.first! ? citiesCurrentWeather[indexPath.row].main.tempInFarenheit : citiesCurrentWeather[indexPath.row].main.tempInCelsius
        cell.cityTemparetureLabel.text = String(temp)+"°"
        cell.timeLabel.text = citiesCurrentWeather[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.row != 0 else { return [] }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            do {
                try self.removeCityCoordinate(at: indexPath.row - 1)
            } catch {
                print(error)
            }
            self.citiesCurrentWeather.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        dvc.selectedCityId = citiesCurrentWeather[indexPath.row].coordinate
        dvc.isTempScaleToggled = isTempScaleToggled.first!
        dvc.currentWeather = citiesCurrentWeather[indexPath.row]
        self.present(dvc, animated: true, completion: nil)
        
    }
}

extension CitiesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.first!
        let localCoordinate = Coordinate(lon: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude)
        NetworkManager.shared.getCityCurrentWeather(coordinate: localCoordinate) { (weather, error) in
            guard var weather = weather else { return }
            weather.name += " 📍"
            self.citiesCurrentWeather.insert(weather, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            print("allow location")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
