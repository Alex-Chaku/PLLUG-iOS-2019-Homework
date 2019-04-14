//
//  Enums.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

enum BookType: String {
    case jornal = "Journal"
    case book = "Book"
    case fiction = "Fiction"
    case dictionary = "Dictionary"
    case logbooks = "Logbooks"
}

enum BookState: String {
    case taken = "taken"
    case recieved = "recieved"
    case added = "available"
}

enum filterType {
    case available
    case taken
    case all
}

enum booksError: Error {
    case someError(error: String)
}

enum sortType {
    case byName
    case byAuthor
    case byType
    case byDate
    case byHuman
}

