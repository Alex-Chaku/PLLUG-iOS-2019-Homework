//
//  Book.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

struct Book: Hashable, Comparable, Codable {
    var uuid = NSUUID().uuidString.lowercased()
    let author: String
    let type: BookType
    let name: String
    var status: BookState
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case author
        case type
        case name
        case status
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(author, forKey: .author)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        author = try container.decode(String.self, forKey: .author)
        type = try container.decode(BookType.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(BookState.self, forKey: .status)

    }
    
    init(author: String, type: BookType, name: String) {
        self.name = name
        self.author = author
        self.type = type
        self.status = .added
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(author)
        hasher.combine(name)
        hasher.combine(type)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.type.rawValue == rhs.type.rawValue
    }
    static func <(lhs: Book, rhs: Book) -> Bool {
        return lhs.type.rawValue < rhs.type.rawValue
    }
}
