//
//  Enums.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

enum BookType: String, Encodable, Decodable {
    case jornal = "Journal"
    case book = "Book"
    case fiction = "Fiction"
    case dictionary = "Dictionary"
    case logbooks = "Logbooks"
}

enum BookState: String, Encodable, Decodable {
    case taken = "taken"
    case recieved = "recieved"
    case added = "added"
}

enum FilterType {
    case available
    case taken
    case all
}

enum BooksError: Error {
    case someError(error: String)
}

enum SortType {
    case byName
    case byAuthor
    case byType
    case byDate
    case byHuman
}

