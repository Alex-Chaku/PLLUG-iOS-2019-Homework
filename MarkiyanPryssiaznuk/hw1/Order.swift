//
//  Order.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

struct Order: Hashable {
    var book: Book
    var human: Human?
    var date: Date?
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.book == rhs.book && lhs.date == rhs.date && lhs.human == rhs.human
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(human)
        hasher.combine(book)
    }
}
