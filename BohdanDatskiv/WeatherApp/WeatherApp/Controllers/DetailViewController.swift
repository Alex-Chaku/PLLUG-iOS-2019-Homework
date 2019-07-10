//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/17/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - DetailViewController
//----------------------------------------
class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var preassureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCityCoordindate: Coordinate!
    var cityForecast: CityForecast?
    var isTempScaleToggled = false
    var currentWeather: CurrentWeather?
    var dailyForecast = [(key: String, value: [Forecast])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        collectionView.isHidden = true
        tableView.isHidden = true
        NetworkManager.shared.getCityForecast(coordinate: selectedCityCoordindate) { (cityForecast, error) in
            self.cityForecast = cityForecast
            DispatchQueue.main.async {
                self.collectionView.reloadData()

                guard let cityForecast = self.cityForecast else { return }
                let dailyForecast = Dictionary(grouping: cityForecast.forecast, by: {$0.dateInDay})
                /// sorting days
                var sortedDailyForecast = dailyForecast.sorted {$0.value[0].dateText < $1.value[0].dateText }
                sortedDailyForecast.removeFirst()
                self.dailyForecast = sortedDailyForecast
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.tableView.isHidden = false
            }
        }
        guard let currentWeather = self.currentWeather else { return }
        self.cityNameLabel.text = currentWeather.name
        self.windLabel.text = String(currentWeather.wind.speed)+" meter/sec"
        self.cloudsLabel.text = String(currentWeather.clouds.all)+"%"
        self.preassureLabel.text = String(currentWeather.main.pressure)+" hPa"
        self.humidityLabel.text = String(currentWeather.main.humidity)+"%"
        self.descriptionLabel.text = currentWeather.weather.first!.description
        self.sunsetTimeLabel.text = currentWeather.sys.sunset
        self.sunriseTimeLabel.text = currentWeather.sys.sunrise
        let temp = self.isTempScaleToggled ? currentWeather.main.tempInFarenheit : currentWeather.main.tempInCelsius
        self.currentTempLabel.text = String(temp)+"°"
    }

    @IBAction func backToCitiesButtonTapped(_ sender: UIButton) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesWeather") as! CitiesViewController
        self.present(dvc, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard cityForecast != nil else { return 0 }
        /// hourly forecast for 24 hour
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailCollectionViewCell
        guard let cityForecast = cityForecast else { return cell }
        let temp = isTempScaleToggled ? cityForecast.forecast[indexPath.row].main.tempInFarenheit : cityForecast.forecast[indexPath.row].main.tempInCelsius
        cell.tempLabel.text = String(temp)+"°"
        cell.timeLabel.text = cityForecast.forecast[indexPath.row].dateInHour
        cell.weatherImage.image = UIImage(named: cityForecast.forecast[indexPath.row].weather.first!.icon)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! DailyWeatherTableViewCell
        cell.dayNameLabel.text = dailyForecast[indexPath.row].key
        if isTempScaleToggled {
            let maxTemp = dailyForecast[indexPath.row].value.map({$0.main.tempInFarenheit}).max()
            let minTemp = dailyForecast[indexPath.row].value.map({$0.main.tempInFarenheit}).min()
            cell.maxTempLabel.text = String(maxTemp!)
            cell.minTempLabel.text = String(minTemp!)
        } else {
            let maxTemp = dailyForecast[indexPath.row].value.map({$0.main.tempInCelsius}).max()
            let minTemp = dailyForecast[indexPath.row].value.map({$0.main.tempInCelsius}).min()
            cell.maxTempLabel.text = String(maxTemp!)
            cell.minTempLabel.text = String(minTemp!)
        }
        let icons = dailyForecast[indexPath.row].value.map({$0.weather.map({$0.icon}).first!}).map({($0, 1)})
        let countIcons = Dictionary(icons, uniquingKeysWith: +)
        guard let mostUsedIcon = countIcons.max(by: {$0.value < $1.value}) else { return cell }
        cell.weatherImage.image = UIImage(named: mostUsedIcon.key)
        return cell
    }
}
