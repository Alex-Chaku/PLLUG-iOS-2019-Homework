//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/15/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - NetworkResponse
//----------------------------------------
enum NetworkResponse:String {
    case success
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

//----------------------------------------
// MARK: - Result
//----------------------------------------
enum Result<String>{
    case success
    case failure(String)
}

//----------------------------------------
// MARK: - NetworkManager
//----------------------------------------
struct NetworkManager {
    
    static let shared = NetworkManager()
    
    static let forecastAPIKey = "18fa771c83f22c19328d98863faa10c6"
    static let geocodingAPIKey = "AIzaSyD6ke-MXsLkZXlRbI41_tB4N9OL6fBwtQ4"
    let forecastRouter = Router<ForecastApi>()
    let geocodingRouter = Router<GeocodingApi>()
    
    private init() {}
    
    func getCoordinateForLocation(name: String, comletion: @escaping (_ gecoding: Geocoding?,_ error: String?)->()) {
        geocodingRouter.request(.location(name: name)) { data, response, error in
            if error != nil {
                comletion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        comletion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let apiResponse = try decoder.decode(Geocoding.self, from: responseData)
                        comletion(apiResponse, nil)
                    } catch {
                        print(error)
                        comletion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    comletion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getCityCurrentWeather(coordinate: Coordinate, completion: @escaping (_ currentWeather: CurrentWeather?,_ error: String?)->()){
        forecastRouter.request(.weather(coordinate: coordinate)) { data, response, error in
        
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(CurrentWeather.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getCityForecast(coordinate: Coordinate, completion: @escaping (_ cityForecast: CityForecast?,_ error: String?)->()){
        forecastRouter.request(.forecast(coordinate: coordinate)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(CityForecast.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
