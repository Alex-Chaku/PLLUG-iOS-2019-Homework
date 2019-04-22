//
//  Order.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

class Order: Hashable, Codable {
    var book: Book
    var human: Human?
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case book
        case human
        case date
    }
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.book == rhs.book && lhs.date == rhs.date && lhs.human == rhs.human
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        book = try container.decode(Book.self, forKey: .book)
        human = try container.decode(Human.self, forKey: .human)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(book, forKey: .book)
        try container.encode(human!, forKey: .human)
        try container.encode(date, forKey: .date)
    }

    
    init(book: Book, human: Human?, date: Date?) {
        self.book = book
        if let newHuman = human {
            self.human = newHuman
        }
        if let newDate = date {
            self.date = newDate
        }

    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(human)
        hasher.combine(book)
    }
}
