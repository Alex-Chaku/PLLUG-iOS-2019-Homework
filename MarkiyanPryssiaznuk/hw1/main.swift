//
//  main.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 3/22/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

enum BookType: String {
    case jornal
    case book
    case fiction
    case dictionary
    case logbooks
}

enum filterType {
    case available
    case taken
    case all
}

enum booksError: Error {
    case someError(error: String)
}

struct Order: Hashable {
    var book: Book
    var human: Human
    var date: Date
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.book == rhs.book && lhs.date == rhs.date && lhs.human == rhs.human
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(human)
        hasher.combine(book)
    }
}

struct Book: Hashable, Comparable {
    let uuid = NSUUID().uuidString.lowercased()
    let author: String
    let type: BookType
    let name: String
    var status: filterType
    
    init(author: String, type: BookType, name: String) {
        self.name = name
        self.author = author
        self.type = type
        self.status = .available
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(author)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(status)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.type.rawValue == rhs.type.rawValue
    }
    static func <(lhs: Book, rhs: Book) -> Bool {
        return lhs.type.rawValue < rhs.type.rawValue
    }
}


class Human: Hashable {
    
    let name: String
    let surname: String
    let passport: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
        self.passport = NSUUID().uuidString.lowercased()
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.name == rhs.name && lhs.surname == rhs.surname && lhs.passport == rhs.passport
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(surname)
        hasher.combine(passport)
    }
}

class Library {
    enum sortType {
        case byName
        case byAuthor
        case byType
        case byDate
        case byHuman
    }
    
    var takenBooks = Set<Order>()
    var balanceOfBooks: [Book] = []
    var recivedBooks = Set<Order>()
    
    var historyOfTaken: [String : Order] = [:]
    var historyOfRecieved: [String : Order] = [:]
    
}
extension Library {
    final func addNewBook(book: Book) {
        balanceOfBooks.append(book)
        print("our new book \(book.author) \(book.name) \(book.type)")
    }
    
    final func takeBook(book: Book, human: Human) throws {
        var newOrder = Order(book: book, human: human, date: Date())
        if balanceOfBooks.isEmpty {
            print("Book balance is empty")
            throw booksError.someError(error: "Balance of books aren't good")
        } else {
            balanceOfBooks.removeAll { $0.uuid == book.uuid }
        }
        takenBooks.insert(newOrder)
        newOrder.book.status = .taken
        historyOfTaken[book.uuid] = newOrder
    }
    
    final func recieveBook(book: Book? , human: Human) throws {
        guard let newBook = book else { throw booksError.someError(error: "Book is nil") }
        var newOrder = Order(book: newBook, human: human, date: Date())
        recivedBooks.insert(newOrder)
        balanceOfBooks.append(newBook)
        newOrder.book.status = .available
        historyOfRecieved[book!.uuid] = newOrder
    }
}

extension Library {
    
    func filer(filet: filterType) {
        switch filet {
        case .available:
            print(balanceOfBooks)
        case.taken:
            print(takenBooks)
        case .all:
            print("All books: \(balanceOfBooks) \(takenBooks)")
        }
    }
}

extension Library {
    func printTakenBooks() {
        for item in takenBooks {
                print("book with id: \(item.book.uuid) was taken his author: \(item.book.author) | \n name: \(item.book.name) | \n status: \(item.book.status) | \n type: \(item.book.type) | \n it was \(item.book.status) at: \(item.date) | \n by: \(item.human.name) | \n passport: \(item.human.passport)")
            }
    }
    
    func printHistory(book: Book) {
        let calendar = Calendar.current
        
        for (key, value) in historyOfTaken {
            if value.book.uuid == book.uuid {
                 let components = calendar.dateComponents([.day], from: value.date, to: Date())
                  print("book with id: \(key) has history  author: \(value.book.author) | \n name: \(value.book.name) | \n status: \(value.book.status) | \n type: \(value.book.type) | \n it was \(value.book.status) at: \(value.date) to \(components) | \n by: \(value.human.name)  | \n passport: \(value.human.passport)")
            }
        }
        
        for (key, value) in historyOfRecieved {
            if value.book.uuid == book.uuid {
                let components = calendar.dateComponents([.day], from: value.date, to: Date())
                print("book with id: \(key) has history  author: \(value.book.author) | \n name: \(value.book.name) | \n status: \(value.book.status) | \n type: \(value.book.type) | \n it was \(value.book.status) at: \(value.date) to \(components) | \n by: \(value.human.name)  | \n passport: \(value.human.passport)")
            }
        }
        
        
    }
    
    func printBookBalance() {
        if balanceOfBooks.isEmpty != true {
            for book in balanceOfBooks {
                print("now available: \(book.author) \(book.name) \(book.type)")
            }
        } else {
            print("Library doesn't have any available books")
        }
    }
}

extension Library {
    func sort(sort: sortType) -> [Order] {
        let array: [Order] = Array(recivedBooks)
        
        var sorted: [Order] = []
        switch sort {
        case .byAuthor:
            sorted = array.sorted{ $0.book.author < $1.book.author }
        case .byName:
            sorted = array.sorted{ $0.book.name < $1.book.name }
        case .byType:
            sorted = array.sorted{ $0.book.type.rawValue < $1.book.type.rawValue }
        case .byDate:
            sorted = array.sorted{ $0.date < $1.date }
        case .byHuman:
            sorted = array.sorted{ $0.human.passport < $1.human.passport }
        }
        return sorted
    }
}

let book1 = Book(author: "King", type: .book, name: "Cool name")
let book2 = Book(author: "Marshmelow", type: .fiction, name: "Awesome name")
let book3 = Book(author: "Abs", type: .jornal, name: "Unbelivable name")
let book4 = Book(author: "Lolka", type: .fiction, name: "Gorgeous name")

let human1 = Human(name: "Markiayn", surname: "Pryssiaznuk")
let human2 = Human(name: "Ivan", surname: "Pryssiaznuk")

let library = Library()

library.addNewBook(book: book1)
library.addNewBook(book: book2)
library.addNewBook(book: book3)
library.addNewBook(book: book4)

print()
print("-------------------------------------- Added books --------------------------------------")
print()

library.printBookBalance()

do {
    try library.takeBook(book: book1, human: human1)
    try library.takeBook(book: book2, human: human1)
    try library.takeBook(book: book3, human: human2)
} catch booksError.someError(error: "Balance of books aren't good") { }

print()
print("-------------------------------------- Taken books: --------------------------------------")
print()
library.printTakenBooks()


print()
print("-------------------------------------- new available: --------------------------------------")
library.printBookBalance()
print()

do {
    try library.recieveBook(book: book1, human: human1)
    try library.recieveBook(book: book2, human: human1)
    try library.recieveBook(book: book3, human: human1)

} catch booksError.someError(error: "Book is nil") {  }


print()
print("-------------------------------------- Recived books --------------------------------------")
print()

library.printBookBalance()

print()
print("-------------------------------------- History --------------------------------------")
print()
library.printHistory(book: book1)

print("-------------------------------------- Sorted by type: --------------------------------------")
print()
for item in library.sort(sort: .byType) {
    print("book with id: was taken his author: \(item.book.author) | \n name: \(item.book.name) | \n status: \(item.book.status) | \n type: \(item.book.type) | \n it was \(item.book.status) at: \(item.date) | \n by: \(item.human.name) | \n passport: \(item.human.passport)")
}
