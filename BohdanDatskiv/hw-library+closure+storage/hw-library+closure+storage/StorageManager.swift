//
//  StorageManager.swift
//  hw-library+closure+storage
//
//  Created by Bohdan Datskiv on 4/30/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

protocol StorageProtocol {
    func set<T: Encodable>(value: T, key: StorageKey) throws
    func get<T: Decodable>(key: StorageKey) throws -> T
    func remove<T: Decodable>(key: StorageKey) throws -> T
}

protocol StorageKey {
    var key: String { get }
}

struct Failure: Error {
    let code: Int?
    let description: String
}

struct Fail: Error {
    struct StorageFailure: Error {
        static let notFound = Failure(code: nil, description: "Object is not available")
        static let notDecoded = Failure(code: nil, description: "Object can't be decoded")
    }
}

class UserDefaultsStorageManager: StorageProtocol {
    static let shared = UserDefaultsStorageManager()
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

class LocalStorageManager: StorageProtocol {
    static let shared = LocalStorageManager()
    private init() {}
    func set<T>(value: T, key: StorageKey) throws where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(value) else {
            throw Fail.StorageFailure.notDecoded
        }
        guard let baseUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            throw Fail.StorageFailure.notFound
        }
        let url = baseUrl.appendingPathComponent("\(key.key).json")
        do {
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func get<T>(key: StorageKey) throws -> T where T : Decodable {
        guard let baseUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            throw Fail.StorageFailure.notFound
        }
        let url = baseUrl.appendingPathComponent("\(key.key).json")
        guard let data = try? Data(contentsOf: url) else {
            throw Fail.StorageFailure.notFound
        }
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw Fail.StorageFailure.notDecoded
        }
        return decodedData
    }
    
    func remove<T>(key: StorageKey) throws -> T where T : Decodable {
        let object: T = try self.get(key: key)
        guard let baseUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            throw Fail.StorageFailure.notFound
        }
        let url = baseUrl.appendingPathComponent("\(key.key).json")
        do {
            try FileManager.default.removeItem(at: url)
            
        } catch {
            print(error.localizedDescription)
        }
        return object
    }
}
