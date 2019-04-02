//
//  Book.swift
//  pllugHW
//
//  Created by Богдан Дацьків on 3/26/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

class Book {
    
    let uuid: String
    let title: String
    let author: String
    let type: Booktype
    var isAvailable = true
    
    enum Booktype {
        case book
        case magazine
        case newspaper
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

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        guard lhs.uuid == rhs.uuid else { return false }
        return true
    }
}
