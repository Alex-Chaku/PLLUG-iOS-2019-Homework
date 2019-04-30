//
//  Order.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

struct Order: Hashable, Codable {
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
