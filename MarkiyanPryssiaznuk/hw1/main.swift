//
//  main.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 3/22/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

let book1 = Book(author: "Kidryk", type: .book, name: "Bot")
let book2 = Book(author: "Paolini", type: .fiction, name: "Eragon")
let book3 = Book(author: "some author", type: .jornal, name: "Men's health")
let book4 = Book(author: "Paul", type: .dictionary, name: "Pro swift")

let human1 = Human(name: "Markiayn", surname: "Pryssiaznuk")
let human2 = Human(name: "Ivan", surname: "Pryssiaznuk")

let library = Library()


//let libririan = Libririan()
//
//library.addObserver(libririan)
//libririan.listenForChanges(of: library)

do {
    _ = try library.syncronize()
} catch {
    print(error)
}

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
} catch BooksError.someError(error: "Balance of books aren't good") { }

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

} catch BooksError.someError(error: "Book is nil") { }

print()
print("-------------------------------------- Recived books --------------------------------------")
print()

library.printBookBalance()

print()
print("-------------------------------------- History of book --------------------------------------")
print()
library.printHistoryOfBook(book: book1)

print()
print("-------------------------------------- ALL books --------------------------------------")
print()
library.printAll()

print("-------------------------------------- Sorted by type: --------------------------------------")
print()
_ = library.sort(sort: .byName, filter: .available)

print()
print()
print()
do {
    let storagedBooks = try library.getStoredBooks()
    for book in storagedBooks {
        print(book)
    }
    print("-------------------------------------- Get Info from selected file : --------------------------------------")
    let export = Export()
    let ourData = try export.get(fileName: "Bot")
    print(ourData!)
} catch {
    print(error)
}

//do {
//    print("-------------------------------------- Save sorted books in json : --------------------------------------")
//    let export = Export()
//    _ = try export.saveSort(fileName: "Sorted Books", sort: SortType.byName , filter: FilterType.all)
//} catch {
//    print(error)
//}


do {
    _ = try library.syncronize()
} catch {
    print(error)
}

