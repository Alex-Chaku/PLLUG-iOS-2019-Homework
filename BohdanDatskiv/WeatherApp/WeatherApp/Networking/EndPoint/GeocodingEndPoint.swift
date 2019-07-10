//
//  GeocodingEndPoint.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 7/2/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

public enum GeocodingApi {
    case location(name: String)
}

extension GeocodingApi: EndPointType {
    
    var stringBaseURL: String {
        return "https://maps.googleapis.com/maps/api/"
    }
    var baseURL: URL {
        guard let url = URL(string: stringBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .location:
            return "geocode/json"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .location(let name):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["address": name,
                                                      "key": NetworkManager.geocodingAPIKey])
        }
        
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
