//
//  UserDefaultsManager.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 7/1/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

//----------------------------------------
// MARK: - StorageKey
//----------------------------------------
protocol StorageKey {
    var key: String { get }
}

//----------------------------------------
// MARK: - Failure
//----------------------------------------
struct Failure: Error {
    let code: Int?
    let description: String
}

//----------------------------------------
// MARK: - Fail
//----------------------------------------
struct Fail: Error {
    struct StorageFailure: Error {
        static let notFound = Failure(code: nil, description: "Object is not available")
        static let notDecoded = Failure(code: nil, description: "Object can't be decoded")
    }
}

//----------------------------------------
// MARK: - UserDefaultsDataManager
//----------------------------------------
struct UserDefaultsDataManager {
    
    static let shared = UserDefaultsDataManager()
    
    private init() {}
    
    func set<T: Encodable>(value: T, key: StorageKey) throws {        
        let newValue = try JSONEncoder().encode(value)
        UserDefaults.standard.set(newValue, forKey: key.key)
        UserDefaults.standard.synchronize()
    }
    
    func get<T: Decodable>(key: StorageKey) throws -> T {
        guard let data = UserDefaults.standard.value(forKey: key.key) as? Data else {
            throw Fail.StorageFailure.notFound
        }
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data)
            else {
                throw Fail.StorageFailure.notDecoded
        }
        return decodedData
    }
    
    func remove<T: Decodable>(key: StorageKey) throws -> T {
        let object:T = try self.get(key: key)
        UserDefaults.standard.removeObject(forKey: key.key)
        return object
    }
}
