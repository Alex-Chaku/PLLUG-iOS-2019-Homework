//
//  CityForecast.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/17/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - CityForecast
//----------------------------------------
struct CityForecast: Codable {

    let cod: String
    let message: Double
    let resultsCount: Int
    let forecast: [Forecast]
    let city: City
    
    /// Coding keys
    private enum CityForecastCodingKeys: String, CodingKey {        
        case cod
        case message
        case resultsCount = "cnt"
        case forecast = "list"
        case city
    }
    /// Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CityForecastCodingKeys.self)
        cod = try container.decode(String.self, forKey: .cod)
        message = try container.decode(Double.self, forKey: .message)
        resultsCount = try container.decode(Int.self, forKey: .resultsCount)
        forecast = try container.decode([Forecast].self, forKey: .forecast)
        city = try container.decode(City.self, forKey: .city)
    }
}

//----------------------------------------
// MARK: - Forecast
//----------------------------------------
struct Forecast: Codable {
    let date: String
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    
    /// Coding Keys
    private enum ForecastCodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case weather
        case clouds
        case wind
    }
    
    /// Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ForecastCodingKeys.self)
        main = try container.decode(Main.self, forKey: .main)
        let secondsSince1970 = try container.decode(Int.self, forKey: .date)
        date = AppDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(secondsSince1970)), timeZone: timezone, format: .hour)
        weather = try container.decode([Weather].self, forKey: .weather)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        wind = try container.decode(Wind.self, forKey: .wind)
    }

}

//----------------------------------------
// MARK: - City
//----------------------------------------
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int?
    let timezone: Int
}
