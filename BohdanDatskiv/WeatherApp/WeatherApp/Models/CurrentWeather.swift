//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/10/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - CityForecast
//----------------------------------------
struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let date: String
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    /// Coding Keys
    private enum CurrentWeatherCodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case date = "dt"
        case sys
        case timezone
        case id
        case name
        case cod
    }
    
    /// Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentWeatherCodingKeys.self)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        weather = try container.decode([Weather].self, forKey: .weather)
        base = try container.decode(String.self, forKey: .base)
        main = try container.decode(Main.self, forKey: .main)
        visibility = try? container.decode(Int.self, forKey: .visibility)
        wind = try container.decode(Wind.self, forKey: .wind)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        sys = try container.decode(Sys.self, forKey: .sys)
        timezone = try container.decode(Int.self, forKey: .timezone)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cod = try container.decode(Int.self, forKey: .cod)
        let secondsSince1970 = try container.decode(Int.self, forKey: .date)
        date = AppDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(secondsSince1970)), timeZone: TimeZone(secondsFromGMT: timezone)!, format: .hourAndMinutes)
    }
}

//----------------------------------------
// MARK: - Weather
//----------------------------------------
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    /// Coding keys
    private enum WeatherCodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    /// Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
    }

}

//----------------------------------------
// MARK: - Main
//----------------------------------------
struct Main: Codable {
    let tempInCelsius: Int
    let tempInFarenheit: Int
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    
    /// Coding keys
    private enum MainCodingKeys: String, CodingKey {
        case tempInCelsius = "temp"
        case pressure
        case humidity
        case tempMin = "temp_max"
        case tempMax = "temp_min"
    }
    
    /// Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        let temp = try container.decode(Double.self, forKey: .tempInCelsius)
        tempInCelsius = Int(temp)
        tempInFarenheit = Int(temp * 1.8 + 32)
        pressure = try container.decode(Double.self, forKey: .pressure)
        humidity = try container.decode(Double.self, forKey: .humidity)
        tempMin = try container.decode(Double.self, forKey: .tempMin)
        tempMax = try container.decode(Double.self, forKey: .tempMax)
    }
}

//----------------------------------------
// MARK: - Wind
//----------------------------------------
struct Wind: Codable {
    let speed: Double
    let deg: Double?
}

//----------------------------------------
// MARK: - Clouds
//----------------------------------------
struct Clouds: Codable {
    let all: Double
}

//----------------------------------------
// MARK: - Sys
//----------------------------------------
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Double
    let country: String
    let sunrise: String
    let sunset: String
    
    /// Coding keys
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case message
        case country
        case sunrise
        case sunset
    }
    
    /// Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try? container.decode(Int.self, forKey: .type)
        id = try? container.decode(Int.self, forKey: .id)
        message = try container.decode(Double.self, forKey: .message)
        country = try container.decode(String.self, forKey: .country)
        let sunriseSeconds = try container.decode(Int.self, forKey: .sunrise)
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunriseSeconds))
        sunrise = AppDateFormatter.string(from: sunriseDate, timeZone: TimeZone.current, format: .hourAndMinutes)
        let sunsetSeconds = try container.decode(Int.self, forKey: .sunset)
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunsetSeconds))
        sunset = AppDateFormatter.string(from: sunsetDate, timeZone: TimeZone.current, format: .hourAndMinutes)
    }

}

//----------------------------------------
// MARK: - Coordinate
//----------------------------------------
public struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}
