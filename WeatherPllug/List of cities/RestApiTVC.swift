//
//  RestApi.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 7/10/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

extension TableViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        //MARK: - Json Parser
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)")
            .responseJSON {response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonDescription = jsonWeather["description"].stringValue
                let jsonName = jsonResponse["name"].stringValue
                let jsonTemp = jsonResponse["main"]
                let temp = jsonTemp["temp"].intValue
                let tempmax = jsonTemp["temp_max"].intValue
                let tempmin = jsonTemp["temp_min"].intValue
                self.posts.append(Course.init(jsonName: jsonName, temp: temp,
                                              jsonDescription: jsonDescription, tempmax: tempmax, tempmin: tempmin, lon: self.long, lat: self.lat))
                self.addCity()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
}
