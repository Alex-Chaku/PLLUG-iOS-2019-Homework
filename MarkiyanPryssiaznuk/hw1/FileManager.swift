//
//  FileManager.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/19/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

class Export {
    func save(orders: [Order], fileName: String) throws {
        do {
            for item in orders {
                let jsonURL = URL(
                    fileURLWithPath: fileName,
                    relativeTo: FileManager.documentDirectoryURL.appendingPathComponent(item.book.type.rawValue)
                    ).appendingPathExtension("json")
                let jsonEncoder = JSONEncoder()
                jsonEncoder.outputFormatting = .prettyPrinted
                let jsonData = try jsonEncoder.encode(orders)
                try jsonData.write(to: jsonURL)
            }
        } catch {
            print(error)
        }
    }
    
    func get(fileName: String) throws -> String? {
        let jsonURL = URL(
            fileURLWithPath: fileName,
            relativeTo: FileManager.documentDirectoryURL.appendingPathComponent(fileName)
            ).appendingPathExtension("json")
    
        let savedData = try Data(contentsOf: jsonURL)
        let stringData = String(data: savedData, encoding: .utf8)

        return stringData
    }
}

extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
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

protocol StorageProtocol {
    func set<T: Encodable>(value: T, key: StorageKey) throws
    func get<T: Decodable>(key: StorageKey) throws -> T
    func remove<T: Decodable>(key: StorageKey) throws -> T
}

class StorageManager: StorageProtocol {
    static let shared = StorageManager()
    private var storage: StorageProtocol = UserDefaultsStorageManager()
    
    private init() {}
    
    final func set<T>(value: T, key: StorageKey) throws where T : Encodable {
        try storage.set(value: value, key: key)
    }
    
    final func get<T>(key: StorageKey) throws -> T where T : Decodable {
        return try storage.get(key: key)
    }
    
    final func remove<T>(key: StorageKey) throws -> T where T : Decodable {
        return try storage.remove(key: key)
    }
}

class RemoteStorageManager: StorageProtocol {
    func set<T>(value: T, key: StorageKey) throws where T : Encodable {
        assertionFailure("Implement this")
    }
    
    func get<T>(key: StorageKey) throws -> T where T : Decodable {
        throw Fail.StorageFailure.notFound
    }
    
    func remove<T>(key: StorageKey) throws -> T where T : Decodable {
        throw Fail.StorageFailure.notFound
    }
}

class UserDefaultsStorageManager: StorageProtocol {
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
