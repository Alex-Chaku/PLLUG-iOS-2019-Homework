//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/10/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - CitiesViewController
//----------------------------------------
class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var farenheitButton: UIButton!
    @IBOutlet weak var celsiusButton: UIButton!
    var isTempScaleToggled = false
    @IBOutlet weak var tableView: UITableView!
    var citiesCurrentWeather = [CurrentWeather]()
    var locationsId = [Int]()
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocationsId()
        locationsId.forEach { (id) in
            networkManager.getCityCurrentWeather(id: id) { (forecast, error) in
                self.citiesCurrentWeather.append(forecast!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        celsiusButton.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesCurrentWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        cell.cityNameLabel.text = citiesCurrentWeather[indexPath.row].name
        let temp = isTempScaleToggled ? citiesCurrentWeather[indexPath.row].main.tempInFarenheit : citiesCurrentWeather[indexPath.row].main.tempInCelsius
        cell.cityTemparetureLabel.text = String(temp)+"°"
        cell.timeLabel.text = citiesCurrentWeather[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        removeLocationId(at: indexPath.row)
        citiesCurrentWeather.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        dvc.selectedCityId = citiesCurrentWeather[indexPath.row].id
        dvc.isTempScaleToggled = isTempScaleToggled
        let temp = isTempScaleToggled ? citiesCurrentWeather[indexPath.row].main.tempInFarenheit : citiesCurrentWeather[indexPath.row].main.tempInCelsius
        dvc.currentTemp = temp
        dvc.weatherDescription = citiesCurrentWeather[indexPath.row].weather.first!.description
        self.present(dvc, animated: true, completion: nil)

    }
    @IBAction func addCityButtonTapped(_ sender: UIButton) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCity") as! AddCityViewController
        
        self.present(dvc, animated: true, completion: nil)
    }    
    
    func addLocationId(_ id: Int) {
        fetchLocationsId()
        locationsId.append(id)
        UserDefaults.standard.set(locationsId, forKey: "locationsId")
    }
    
    func fetchLocationsId() {
        guard let locationsId = UserDefaults.standard.value(forKey: "locationsId") as? [Int] else { return }
        self.locationsId = locationsId
    }
    
    func removeLocationId(at index: Int) {
        locationsId.remove(at: index)
        UserDefaults.standard.set(locationsId, forKey: "locationsId")
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
        isTempScaleToggled = !isTempScaleToggled
        self.tableView.reloadData()
    }
    
}
