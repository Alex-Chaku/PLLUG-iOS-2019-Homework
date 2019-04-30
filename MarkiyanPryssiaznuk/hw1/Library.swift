//
//  Library.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

class Library {
     public enum Key: String, StorageKey {
        var key: String {
            return self.rawValue
        }
        case books
    }
    
    private var completionHandler: [(() -> (Void), BookState)] = []
    
    private var observers: [LibraryObserver] = []
    static let shared = Library()
    weak var delegate: LibraryDelegate?
    
    fileprivate var takenBooks = Set<Order>()
    fileprivate var balanceOfBooks = Set<Order>()

    fileprivate var historyOfTaken: [String : Order] = [:]
    fileprivate var historyOfRecieved: [String : Order] = [:]
    
    private let export = Export()
    
    func syncronize() throws {
        if balanceOfBooks.isEmpty {
            let removedBooks: [Order] = try StorageManager.shared.remove(key: Key.books)
            print("Storage was syncronazed & removed those items")
            print()
            removedBooks.forEach { (order) in
                print(order.book.name)
            }
        } else {
            _ = try StorageManager.shared.set(value: balanceOfBooks, key: Key.books)
            print("Storage was syncronazed & seted our books")
        }
    }
}

extension Library {
    func getStoredBooks() throws -> Set<Order> {
        return try StorageManager.shared.get(key: Key.books)
    }
}

extension Library {
    final func addNewBook(book: Book) {
        let newOrder = Order(book: book, human: nil, date: nil)
        balanceOfBooks.insert(newOrder)
        notify(book, bookState: .added)
        delegate?.bookWasAdded(book: book)
        do {
            try StorageManager.shared.set(value: balanceOfBooks, key: Key.books)
        } catch {
            print(error)
        }
    }
    
    final func takeBook(book: Book, human: Human) throws {
        var newOrder = Order(book: book, human: human, date: Date())
        if balanceOfBooks.isEmpty {
            print("Book balance is empty")
            throw booksError.someError(error: "Balance of books aren't good")
        } else {
            _ = balanceOfBooks.filter( { $0.book.uuid.hashValue == newOrder.book.uuid.hashValue }).map( { balanceOfBooks.remove($0)})
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
        _ = takenBooks.filter( { $0.book.uuid.hashValue == newOrder.book.uuid.hashValue }).map( { takenBooks.remove($0)})
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
       _ = takenBooks.map {
            let book = $0.book
            guard let human = $0.human else { return }
            guard let date = $0.date else { return }
            
            print("book with id: \(book.uuid) was taken his author: \(book.author) | \n name: \(book.name) | \n status: \(book.status) | \n type: \(book.type) | \n it was \(book.status) at: \(date) | \n by: \(human.name) | \n passport: \(human.passport)")
        }
    }
    
    func printHistoryOfBook(book: Book) {
        let calendar = Calendar.current
        var generalSet : [Order] = []
        for (key, value) in historyOfTaken {
            let dictBook = value.book
            guard let human = value.human else { return }
            guard let date = value.date else { return }
            if value.book.uuid == book.uuid {
                guard let dateFrom = value.date else { return }
                let components = calendar.dateComponents([.day], from: dateFrom, to: Date())
                
                let finalstring = "book with id: \(key) has history  author: \(dictBook.author) | \n name: \(dictBook.name) | \n status: \(dictBook.status) | \n type: \(dictBook.type) | \n it was \(dictBook.status) at: \(date) to \(components) | \n by: \(human.name)  | \n passport: \(human.passport)"
                
                generalSet.append(value)
                print(finalstring)
            }
        }
        
        for (key, value) in historyOfRecieved {
            let dictBook = value.book
            guard let human = value.human else { return }
            guard let date = value.date else { return }
            if value.book.uuid == book.uuid {
                guard let dateFrom = value.date else { return }
                let components = calendar.dateComponents([.day], from: dateFrom, to: Date())
                
                let finalstring = "book with id: \(key) has history  author: \(dictBook.author) | \n name: \(dictBook.name) | \n status: \(dictBook.status) | \n type: \(dictBook.type) | \n it was \(dictBook.status) at: \(date) to \(components) | \n by: \(human.name)  | \n passport: \(human.passport)"
            
                generalSet.append(value)
                print(finalstring)
            }
        }
        var name: String = ""
        generalSet.forEach { (order) in
            name = order.book.name
        }
        do { try export.save(orders: generalSet, fileName: name) } catch { print(error) }
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
    
    func printAll() {
        print("taken ones:")
        printTakenBooks()
        print("Available ones:")
        printBookBalance() }
}

extension Library {
    func sort(sort: sortType, filter: filterType) {
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
        
        sorted.forEach { (item) in
                let book = item.book
                let human = item.human
                let date = item.date
            print("book with id: was taken his author: \(book.author) | \n name: \(book.name) | \n status: \(book.status) | \n type: \(book.type) | \n it was \(book.status) at: \(String(describing: date)) | \n by: \(String(describing: human?.name)) | \n passport: \(String(describing: human?.passport))")
        }
        
        do { try export.save(orders: sorted, fileName: "Sorted Books") } catch { print(error) }

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
            observer.notifyEnd {
                print("Observer: \(book.name) was \(bookState)")
            }
        }
    }
}

protocol Observable: class {
    func addObserver(_ observer: LibraryObserver)
    func removeObserber(_ observer: LibraryObserver)
    func notify(_ book: Book, bookState: BookState)
}

protocol LibraryObserver: class {
    func notifyEnd(_: () -> ())
}

class Libririan: LibraryObserver {
    func notifyEnd(_ completion: () -> ()) {
        completion()
    }
}

protocol LibraryDelegate: class {
    func bookWasAdded(book: Book)
    func bookWasTaken(book: Book)
    func bookWasReturned(book: Book)
}

extension Libririan: LibraryDelegate {
    
    func bookWasAdded(book: Book) {
        print("Delegate: \(book.name) was added")
    }
    
    func bookWasTaken(book: Book) {
        print("Delegate: \(book.name) was taken")
    }
    
    func bookWasReturned(book: Book) {
        print("Delegate: \(book.name) was recieved")
    }
    
    func listenForChanges(of library: Library? = nil) {
        if let library = library {
            library.delegate = self
        } else {
            Library.shared.delegate = self
        }
    }
    
}
