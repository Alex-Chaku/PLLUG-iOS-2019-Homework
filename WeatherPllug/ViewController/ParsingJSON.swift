//
//  ParsingJSON.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 7/7/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

extension ViewController {
    func occasionally() {
    Alamofire.request("https://samples.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(long)&cnt=10&appid=f23e9fefec26a337e0a58ad0502bed89")
        .responseJSON { response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                for i in 0..<7{
                    let jsonTemp = jsonResponse["list"].array![i]
                    let tempMain = jsonTemp["temp"]
                    let tampmin = tempMain["min"].intValue
                    let tampmax = tempMain["max"].intValue

                    let timeResult = jsonTemp["dt"].doubleValue
                    let date = Date(timeIntervalSince1970: timeResult)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                    dateFormatter.timeZone = .current
                    let localDate = dateFormatter.string(from: date)
                    let jsonWeatherDays = jsonTemp["weather"].array![0]
                    let iconNameDays = jsonWeatherDays["icon"].stringValue
                    let mainImageDays = UIImage(named: iconNameDays)
                    self.days.append(Days.init(day: self.convertUTC(dateToConvert: localDate),
                    tampmax: tampmax, tampmin: tampmin, daysImg: mainImageDays))
                }
            }
        }
    }
    func hourlyWeather() {
        Alamofire.request("https://samples.openweathermap.org/data/2.5/forecast/hourly?lat=\(lat)&lon=\(long)&appid=\(apiKey)")
            .responseJSON { response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                for i in 0..<14 {
                    let jsonTemp = jsonResponse["list"].array![i]
                    let tempmain = jsonTemp["main"]
                    let tempdt = tempmain["temp"].intValue
                    let dtTxt = (jsonTemp["dt_txt"]).stringValue
                    let jsonWeather = jsonTemp["weather"].array![0]
                    let iconName = jsonWeather["icon"].stringValue
                    let mainImage = UIImage(named: iconName)
                    self.LabelLocation.text = self.jsonName
                    self.LabelDecription.text = self.jsonDescription
                    self.convertUTCDate(dateToConvert: dtTxt)
                    self.masHourly.append(Hourly.init(tempdt: tempdt, datedt: self.hour, iconName: mainImage))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
