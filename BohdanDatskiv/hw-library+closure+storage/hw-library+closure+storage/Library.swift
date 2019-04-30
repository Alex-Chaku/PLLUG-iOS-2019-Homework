
//
//  Library.swift
//  pllugHW
//
//  Created by Богдан Дацьків on 3/26/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation



typealias History = (book: Book, person: Person, giveDate: Date, returnDate: Date?)

func notify(_ completion: ()->()) {
    completion()
}

enum libraryErrors: String, Error {
    case wrongBook = "Wrong book"
    case alreadyExist = "Already exist"
}

class Library {
    private enum Key: String, StorageKey {
        var key: String {
            return self.rawValue
        }
        case books
    }
    
    var booksInLibrary = [Book]() {
        didSet {
            
        }
    }
    var history = [History]()
    
    func addBook(_ book: Book) throws {
        booksInLibrary.append(book)
        try LocalStorageManager.shared.set(value: booksInLibrary, key: Key.books)
        try UserDefaultsStorageManager.shared.set(value: booksInLibrary, key: Key.books)
        notify {
            print("Added \(book.type): '\(book.title)' \(book.author)")
        }
    }
    
    func getStoredBooksFromUserDefaults() throws -> [Book] {
        return try UserDefaultsStorageManager.shared.get(key: Key.books)
    }
    
    func getSroredBooksFromFile() throws -> [Book] {
        return try LocalStorageManager.shared.get(key: Key.books)
    }
    
    func removeBooksFromUserDefaults() throws -> [Book] {
        return try UserDefaultsStorageManager.shared.remove(key: Key.books)
    }
    
    func removeBooksFromFile() throws -> [Book] {
        return try LocalStorageManager.shared.remove(key: Key.books)
    }
    
    func giveBook(_ book: Book, to person: Person) throws {
        guard let index = booksInLibrary.firstIndex(where: {$0.uuid == book.uuid}) else { throw libraryErrors.wrongBook }
        book.isAvailable = false
        history.insert((book.copy(), person, Date(), nil), at: 0)
        booksInLibrary[index].isAvailable =  false
        notify {
             print("\(book.type): '\(book.title)' \(book.author) has given to \(person.name) \(person.surname)")
        }
    }
    
    func returnBook(_ book: Book) throws {
        guard let indexInHistory = history.firstIndex(where: {$0.book == book}) else { throw libraryErrors.wrongBook }
        guard let indexInBooks = booksInLibrary.firstIndex(where: {$0 == book}) else { throw libraryErrors.wrongBook }
        history[indexInHistory].returnDate = Date()
        history[indexInHistory].book.isAvailable = true
        booksInLibrary[indexInBooks].isAvailable = true
        notify {
            print("\(book.type): '\(book.title)' \(book.author) was returned")
        }
    }
    
    enum booksState {
        case all
        case available
        case unavailable
    }
    
    func historyOfBook(_ book: Book) {
        guard history.contains(where: {$0.book == book}) else { return }
        for record in history {
            guard record.book.uuid == book.uuid else { continue }
            if let returnDate = record.returnDate {
                guard let days = daysBetweenDates(startDate: record.giveDate, endDate: returnDate) else { continue }
                print("The \(book.type): \(book.title) \(book.author) \(book.type) has given to \(record.person.name) \(record.person.surname) for \(days) days")
            } else {
                guard let days = daysBetweenDates(startDate: record.giveDate, endDate: Date()) else { continue }
                print("The \(book.type): \(book.title) \(book.author) \(book.type) has given to \(record.person.name) \(record.person.surname) \(days) days ago")
            }
        }
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int?
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }
    
    enum SortType {
        case person
        case title
        case author
        case date
    }
    
    func listOfBooksInLibrary(filter: booksState, sortedBy: SortType) {
        switch (filter, sortedBy) {
        case (.all, .title):
            booksInLibrary.sort { $0.title < $1.title }
            for book in booksInLibrary {
                print("\(book.type): '\(book.title)' \(book.author)")
            }
        case (.all, .author):
            booksInLibrary.sort { $0.author < $1.author }
            for book in booksInLibrary {
                print("\(book.type): '\(book.title)' \(book.author)")
            }
        case (.available, .title):
            booksInLibrary.sort { $0.title < $1.title }
            for book in booksInLibrary
            {
                guard book.isAvailable else { continue }
                print("\(book.type): '\(book.title)' \(book.author)")
            }
        case (.available, .author):
            booksInLibrary.sort { $0.author < $1.author }
            for book in booksInLibrary
            {
                guard book.isAvailable else { continue }
                print("\(book.type): '\(book.title)' \(book.author)")
            }
        case (.unavailable, .title):
            booksInLibrary.sort { $0.title < $1.title }
            for book in booksInLibrary
            {
                guard !book.isAvailable else { continue }
                guard let index = history.firstIndex(where: {$0.book == book}) else { continue }
                guard let days = daysBetweenDates(startDate: history[index].giveDate, endDate: Date()) else { continue }
                print("\(book.type): '\(book.title)' \(book.author) has given to \(history[index].person.name) \(history[index].person.surname) \(days) days ago")
            }
        case (.unavailable, .author):
            booksInLibrary.sort { $0.author < $1.author }
            for book in booksInLibrary
            {
                guard !book.isAvailable else { continue }
                guard let index = history.firstIndex(where: {$0.book == book}) else { continue }
                guard let days = daysBetweenDates(startDate: history[index].giveDate, endDate: Date()) else { continue }
                print("\(book.type): '\(book.title)' \(book.author) has given to \(history[index].person.name) \(history[index].person.surname) \(days) days ago")
            }
        case (.unavailable, .date):
            history.sort { $0.giveDate > $1.giveDate }
            for record in history {
                guard !record.book.isAvailable else { continue }
                guard let days = daysBetweenDates(startDate: record.giveDate, endDate: Date()) else { continue }
                print("\(record.book.type): '\(record.book.title)' \(record.book.author) has given to \(record.person.name) \(record.person.surname) \(days)  days agoo")
            }
        case (.unavailable, .person):
            history.sort { $0.person.surname < $1.person.surname }
            for record in history {
                guard !record.book.isAvailable else { continue }
                guard let days = daysBetweenDates(startDate: record.giveDate, endDate: Date()) else { continue }
                print("\(record.book.type): '\(record.book.title)' \(record.book.author) has given to \(record.person.name) \(record.person.surname) \(days) days ago")
            }
        default:
            print("Wrong input")
        }
    }
}
