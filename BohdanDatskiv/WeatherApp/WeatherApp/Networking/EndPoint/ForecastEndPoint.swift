//
//  ForecastEndPoint.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/15/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - NetworkEnvironment
//----------------------------------------
enum NetworkEnvironment {
    case production
}

//----------------------------------------
// MARK: - ForecastApi
//----------------------------------------
public enum ForecastApi {
    case weather(id: Int)
    case forecast(id: Int)
}

extension ForecastApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.openweathermap.org/data/2.5/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
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
        case .weather(let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id,
                                                      "units":"metric",
                                                      "appid":NetworkManager.APIKey])
        case .forecast(let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id,
                                                      "units":"metric",
                                                      "appid":NetworkManager.APIKey])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
