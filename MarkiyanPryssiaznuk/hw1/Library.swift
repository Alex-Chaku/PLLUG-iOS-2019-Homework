//
//  Library.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

class Library {
    private var observers: [LibraryObserver] = []
    static let shared = Library()
    weak var delegate: LibraryDelegate?
    
    private var takenBooks = Set<Order>()
    private var balanceOfBooks = Set<Order>()
    
    private var historyOfTaken: [String : Order] = [:]
    private var historyOfRecieved: [String : Order] = [:]
}

extension Library {
    final func addNewBook(book: Book) {
        let newOrder = Order(book: book, human: nil, date: nil)
        balanceOfBooks.insert(newOrder)
        notify(book, bookState: .added)
        delegate?.bookWasAdded(book: book)
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
        notify(book, bookState: .taken)
        delegate?.bookWasTaken(book: book)
        newOrder.book.status = .taken
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
        notify(book!, bookState: .recieved)
        delegate?.bookWasReturned(book: book!)
        balanceOfBooks.insert(newOrder)
        newOrder.book.status = .recieved
        historyOfRecieved[book!.uuid] = newOrder
    }
}

extension Library {
    final func filer(filet: filterType) {
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
    
    func printHistoryOfBook(book: Book) {
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
    
    func printAll() { print("taken ones:");printTakenBooks();print("Available ones:");printBookBalance() }
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


extension Library: Observable {
    
    func addObserver(_ observer: LibraryObserver) {
        if observers.contains(where: { $0 === observer } ) == false {
            observers.append(observer)
        }
    }
    
    func removeObserber(_ observer: LibraryObserver) {
        if let index = observers.firstIndex(where: { $0 === observer } ) {
            observers.remove(at: index)
        }
    }
    
    func notify(_ book: Book, bookState: BookState) {
        observers.forEach { observer in
            observer.notifyActionDone(book: book, bookState: bookState.rawValue)
        }
    }
}

protocol Observable: class {
    
    func addObserver(_ observer: LibraryObserver)
    func removeObserber(_ observer: LibraryObserver)
    func notify(_ book: Book, bookState: BookState)
    
}


protocol LibraryObserver: class {
    func notifyActionDone(book: Book, bookState: String)
}

class Libririan: LibraryObserver {
    func notifyActionDone(book: Book, bookState: String) {
        print("Observer: \(book) was \(bookState)")
    }
}

protocol LibraryDelegate: class {
    
    func bookWasAdded(book: Book)
    func bookWasTaken(book: Book)
    func bookWasReturned(book: Book)
    
}

extension Libririan: LibraryDelegate {
    
    func bookWasAdded(book: Book) {
        print("Delegate: \(book) was added")
    }
    
    func bookWasTaken(book: Book) {
        print("Delegate: \(book) was taken")
    }
    
    func bookWasReturned(book: Book) {
        print("Delegate: /n name :\(book.name) status: \(book.status) was recieved")
    }
    
    func listenForChanges(of library: Library? = nil) {
        if let library = library {
            library.delegate = self
        } else {
            Library.shared.delegate = self
        }
    }
    
}
