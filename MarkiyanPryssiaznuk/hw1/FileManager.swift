//
//  FileManager.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/19/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

//class Export {
//    func save(directory: FileManager.SearchPathDirectory) throws {
//        let kindDirectoryURL = URL(
//            fileURLWithPath: kind.rawValue,
//            relativeTo: FileManager.default.urls(for: directory, in: .userDomainMask)[0]
//        )
//
//}
//
//extension FileManager {
//    static var documentDirectoryURL: URL {
//        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    }
//}

//
protocol StorageKey {
    var key: String { get }
}
//
struct Failure: Error {
    let code: Int?
    let description: String
}
//
struct Fail: Error {
    struct StorageFailure: Error {
        static let notFound = Failure(code: nil, description: "Object is not available")
        static let notDecoded = Failure(code: nil, description: "Object can't be decoded")
    }
}
//
protocol StorageProtocol {
    func set<T: Encodable>(value: T, key: StorageKey) throws
    func get<T: Decodable>(key: StorageKey) throws -> T
    func remove<T: Decodable>(key: StorageKey) throws -> T
}
//
class StorageManager: StorageProtocol {
    static let shared = StorageManager()
    private var storage: StorageProtocol = UserDefaultsStorageManager()
    
    private init() {}
    
    func set<T>(value: T, key: StorageKey) throws where T : Encodable {
        try storage.set(value: value, key: key)
    }
    
    func get<T>(key: StorageKey) throws -> T where T : Decodable {
        return try storage.get(key: key)
    }
    
    func remove<T>(key: StorageKey) throws -> T where T : Decodable {
        return try storage.remove(key: key)
    }
}
//
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
//
//class Book: Codable {
//    let id = UUID().uuidString
//    let title: String
//    let author: String
//    
//    init(title: String, author: String) {
//        self.title = title
//        self.author = author
//    }
//}
//
//class Library {

//
//    var books = [Book]()
//    
//    func add(book: Book) throws {
//        books.append(book)
//        try StorageManager.shared.set(value: books, key: Key.books)
//    }
//    
//    func getStoredBooks() throws -> [Book] {
//        return try StorageManager.shared.get(key: Key.books) as [Book]
//    }
//}
//
//let book = Book(title: "Lolka", author: "Bohdan")
//let library = Library()
//do {
//    try library.add(book: book)
//    let some = try library.getStoredBooks()
//    print(some[0].title)
//} catch {
//}

