//
//  ForecastEndPoint.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/15/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - ForecastApi
//----------------------------------------
public enum ForecastApi {
    case weather(coordinate: Coordinate)
    case forecast(coordinate: Coordinate)
}

extension ForecastApi: EndPointType {
    
    var stringBaseURL : String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: stringBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .weather:
            return "weather"
        case .forecast:
            return "forecast"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .weather(let coordinate):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["lat":coordinate.lat,
                                                      "lon":coordinate.lon,
                                                      "units":"metric",
                                                      "appid":NetworkManager.forecastAPIKey])
        case .forecast(let coordinate):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["lat":coordinate.lat,
                                                      "lon":coordinate.lon,
                                                      "units":"metric",
                                                      "appid":NetworkManager.forecastAPIKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
