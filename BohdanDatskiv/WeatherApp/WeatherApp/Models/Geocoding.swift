//
//  Geoding.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 7/2/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - Geocoding
//----------------------------------------
struct Geocoding: Codable {
    let status: String
    let results: [Results]
}

//----------------------------------------
// MARK: - Results
//----------------------------------------
struct Results: Codable {
    let addressComponents: [AddressComponents]
    let formattedAddress: String
    let geometry: Geometry
    let placeId: String
    let types: [String]
}

//----------------------------------------
// MARK: - AddressComponents
//----------------------------------------
struct AddressComponents: Codable {
    let longName: String
    let shortName: String
    let types: [String]
}

//----------------------------------------
// MARK: - Geometry
//----------------------------------------
struct Geometry: Codable {
    let bounds: Bounds?
    let location: Location
    let locationType: String
    let viewport: Viewport
}

//----------------------------------------
// MARK: - Bounds
//----------------------------------------
struct Bounds: Codable {
    let northeast: Location
    let southwest: Location
}

//----------------------------------------
// MARK: - Location
//----------------------------------------
struct Location: Codable {
    let lat: Double
    let lng: Double
}

//----------------------------------------
// MARK: - Viewport
//----------------------------------------
struct Viewport: Codable {
    let northeast: Location
    let southwest: Location
}
