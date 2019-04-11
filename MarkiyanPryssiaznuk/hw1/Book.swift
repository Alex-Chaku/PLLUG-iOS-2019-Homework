//
//  Book.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

struct Book: Hashable, Comparable {
    let uuid = NSUUID().uuidString.lowercased()
    let author: String
    let type: BookType
    let name: String
    var status: BookState
    
    init(author: String, type: BookType, name: String) {
        self.name = name
        self.author = author
        self.type = type
        self.status = .some(status: "available")
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
