//
//  History.swift
//  hw-library+closure+storage
//
//  Created by Bohdan Datskiv on 4/30/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation


struct History: Codable {
    var book: Book
    var person: Person
    var giveDate: Date
    var returnDate: Date?
}
