//
//  CityData.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/9/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - City
//----------------------------------------
struct CityData: Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinate
}

//----------------------------------------
// MARK: - Coordinate
//----------------------------------------
struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}
