//
//  Book.swift
//  pllugHW
//
//  Created by Богдан Дацьків on 3/26/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

class Book: Codable {
    
    let uuid: String
    let title: String
    let author: String
    let type: Booktype
    var isAvailable = true
    
    enum Booktype: Codable {
        
        enum Key: CodingKey {
            case rawValue
        }
        
        enum CodingError: Error {
            case unknownValue
        }
        
        case book
        case magazine
        case newspaper
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            let rawValue = try container.decode(Int.self, forKey: .rawValue)
            switch rawValue {
            case 0:
                self = .book
            case 1:
                self = .magazine
            case 2:
                self = .newspaper
            default:
                throw CodingError.unknownValue
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            switch self {
            case .book:
                try container.encode(0, forKey: .rawValue)
            case .magazine:
                try container.encode(1, forKey: .rawValue)
            case .newspaper:
                try container.encode(2, forKey: .rawValue)
            }
        }
    }
    init(uuid: String = UUID().uuidString, title: String, author: String, type: Booktype) {
        self.uuid = uuid
        self.title = title
        self.author = author
        self.type = type
    }
    private init(object: Book) {
        self.uuid = object.uuid
        self.title = object.title
        self.author = object.author
        self.type = object.type
        self.isAvailable = object.isAvailable
    }
    func copy() -> Book {
        return Book(object: self)
    }
}

extension Book: Hashable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        guard lhs.uuid == rhs.uuid else { return false }
        return true
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
