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
class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var preassureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let networkManager = NetworkManager()
    var selectedCityId: Int!
    var cityForecast: CityForecast?
    var isTempScaleToggled = false
    var currentTemp: Int!
    var weatherDescription: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getCityForecast(id: selectedCityId) { (cityForecast, error) in
            self.cityForecast = cityForecast
            DispatchQueue.main.async {
                self.cityNameLabel.text = cityForecast!.city.name
                self.windLabel.text = String(cityForecast!.forecast.first!.wind.speed)+" meter/sec"
                self.cloudsLabel.text = String(cityForecast!.forecast.first!.clouds.all)+"%"
                self.preassureLabel.text = String(cityForecast!.forecast.first!.main.pressure)+" hPa"
                self.humidityLabel.text = String(cityForecast!.forecast.first!.main.humidity)+"%"
                self.currentTempLabel.text = String(self.currentTemp)
                self.descriptionLabel.text = self.weatherDescription
                self.collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard cityForecast != nil else { return 0 }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailCollectionViewCell
        guard let cityForecast = cityForecast else { return cell }
        let temp = isTempScaleToggled ? cityForecast.forecast[indexPath.row].main.tempInFarenheit : cityForecast.forecast[indexPath.row].main.tempInCelsius
        cell.tempLabel.text = String(temp)+"°"
        cell.timeLabel.text = cityForecast.forecast[indexPath.row].date
        guard let imageData = try? Data(contentsOf: cityForecast.forecast[indexPath.row].weather.first!.icon!) else { return cell }
        cell.weatherImage.image = UIImage(data: imageData)
        return cell
    }
    
    @IBAction func backToCitiesButtonTapped(_ sender: UIButton) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesWeather") as! CitiesViewController
        dvc.isTempScaleToggled = isTempScaleToggled
        self.present(dvc, animated: true, completion: nil)
    }
    
}
