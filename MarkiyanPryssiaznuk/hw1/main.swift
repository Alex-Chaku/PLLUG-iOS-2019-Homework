//
//  main.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 3/22/19.
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

enum BookState {
    case some(status: String)
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

    private var takenBooks = Set<Order>()
    private var balanceOfBooks = Set<Order>()
    
    private var historyOfTaken: [String : Order] = [:]
    private var historyOfRecieved: [String : Order] = [:]
    
}

extension Library {
    final func addNewBook(book: Book) {
        let newOrder = Order(book: book, human: nil, date: nil)
        balanceOfBooks.insert(newOrder)
        print("our new book \(newOrder.book.author) \(newOrder.book.name) \(newOrder.book.type)")
    }
    
    final func takeBook(book: Book, human: Human) throws {
        var newOrder = Order(book: book, human: human, date: Date())
        if balanceOfBooks.isEmpty {
            print("Book balance is empty")
            throw booksError.someError(error: "Balance of books aren't good")
        } else {
            for item in balanceOfBooks {
                if newOrder.book.uuid.hashValue == item.book.uuid.hashValue {
                    balanceOfBooks.remove(item)
                }
            }
        }
        newOrder.book.status = .some(status: "taken")
        takenBooks.insert(newOrder)
        historyOfTaken[book.uuid] = newOrder
    }
    
    final func recieveBook(book: Book? , human: Human) throws {
        guard let newBook = book else { throw booksError.someError(error: "Book is nil") }
        var newOrder = Order(book: newBook, human: human, date: Date())
        for item in takenBooks {
            if newOrder.book.uuid.hashValue == item.book.uuid.hashValue {
                takenBooks.remove(item)
            }
        }
        balanceOfBooks.insert(newOrder)
        newOrder.book.status = .some(status: "available")
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
            let book = item.book
            guard let human = item.human else { return }
            guard let date = item.date else { return }

                print("book with id: \(book.uuid) was taken his author: \(book.author) | \n name: \(book.name) | \n status: \(book.status) | \n type: \(book.type) | \n it was \(book.status) at: \(date) | \n by: \(human.name) | \n passport: \(human.passport)")
            }
    }
    
    func printHistory(book: Book) {
        let calendar = Calendar.current
        
        for (key, value) in historyOfTaken {
            let dictBook = value.book
            guard let human = value.human else { return }
            guard let date = value.date else { return }
            if value.book.uuid == book.uuid {
                guard let dateFrom = value.date else { return }
                 let components = calendar.dateComponents([.day], from: dateFrom, to: Date())
                  print("book with id: \(key) has history  author: \(dictBook.author) | \n name: \(dictBook.name) | \n status: \(dictBook.status) | \n type: \(dictBook.type) | \n it was \(dictBook.status) at: \(date) to \(components) | \n by: \(human.name)  | \n passport: \(human.passport)")
            }
        }
        
        for (key, value) in historyOfRecieved {
            let dictBook = value.book
            guard let human = value.human else { return }
            guard let date = value.date else { return }
            if value.book.uuid == book.uuid {
                guard let dateFrom = value.date else { return }
                let components = calendar.dateComponents([.day], from: dateFrom, to: Date())
                print("book with id: \(key) has history  author: \(dictBook.author) | \n name: \(dictBook.name) | \n status: \(dictBook.status) | \n type: \(dictBook.type) | \n it was \(dictBook.status) at: \(date) to \(components) | \n by: \(human.name)  | \n passport: \(human.passport)")
            }
        }
    }
    
    func printBookBalance() {
        if balanceOfBooks.isEmpty != true {
            for item in balanceOfBooks {
                print("now available: \(item.book.author) \(item.book.name) \(item.book.type)")
            }
        } else {
            print("Library doesn't have any available books")
        }
    }
}

extension Library {
    func sort(sort: sortType, filter: filterType) -> [Order] {
        var array: [Order] = []
        var sorted: [Order] = []
        
        switch filter {
        case .all:
            array = Array(balanceOfBooks.symmetricDifference(takenBooks))
        case .available:
            array = Array(balanceOfBooks)
        case .taken:
            array = Array(takenBooks)
        }
        
        switch sort {
        case .byAuthor:
            sorted = array.sorted{ $0.book.author < $1.book.author }
        case .byName:
            sorted = array.sorted{ $0.book.name < $1.book.name }
        case .byType:
            sorted = array.sorted{ $0.book.type.rawValue < $1.book.type.rawValue }
        case .byDate:
            sorted = array.sorted{ $0.date! < $1.date! }
        case .byHuman:
            sorted = array.sorted{ $0.human!.passport < $1.human!.passport }
        }
        return sorted
    }
}

let book1 = Book(author: "King", type: .book, name: "Cool name")
let book2 = Book(author: "Marshmelow", type: .fiction, name: "Awesome name")
let book3 = Book(author: "Abs", type: .jornal, name: "Unbelivable name")
let book4 = Book(author: "Lolka", type: .dictionary, name: "Gorgeous name")


let human1 = Human(name: "Markiayn", surname: "Pryssiaznuk")
let human2 = Human(name: "Ivan", surname: "Pryssiaznuk")

let library = Library()

print("-------------------------------------- Created books --------------------------------------")
print()

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
print("-------------------------------------- now available: --------------------------------------")
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
for item in library.sort(sort: .byType, filter: .available) {
    let book = item.book
    let human = item.human ?? nil
    let date = item.date ?? nil
    print("book with id: was taken his author: \(book.author) | \n name: \(book.name) | \n status: \(book.status) | \n type: \(book.type) | \n it was \(book.status) at: \(String(describing: date)) | \n by: \(String(describing: human?.name)) | \n passport: \(String(describing: human?.passport))")
}
