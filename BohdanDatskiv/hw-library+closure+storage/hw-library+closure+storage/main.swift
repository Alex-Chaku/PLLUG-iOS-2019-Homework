//
//  main.swift
//  hw-library+closure+storage
//
//  Created by Bohdan Datskiv on 4/30/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

let person1 = Person(name: "Bohdan", surname: "Datskiv")

let library = Library()

var book1 = Book(title: "The Great Gatsby", author: "Scott Fitzgerald", type: .book)
var book2 = Book(title: "To Kill a Mockingbird", author: "Harper Lee", type: .book)

do {
    library.booksInLibrary = try library.getStoredBooks()
} catch {
    print(error.localizedDescription)
}

var test = [History]()
do {
    library.history = try library.getSroredHistory()
} catch {
    print(error)
}


do {
    try library.addBook(book1)
    try library.addBook(book2)
} catch {
    print(error.localizedDescription)
}
do{
    try library.giveBook(book1, to: person1)
    try library.giveBook(book2, to: person1)
    try library.returnBook(book1)
} catch {
    print(error.localizedDescription)
}

print("List of books in library filter: all and sorted by title")
library.listOfBooksInLibrary(filter: .all, sortedBy: .title)
print("\nList of books in library filter: all and sorted by author")
library.listOfBooksInLibrary(filter: .all, sortedBy: .author)
print("\nList of books in library filter: available and sorted by title")
library.listOfBooksInLibrary(filter: .available, sortedBy: .title)
print("\nList of books in library filter: available and sorted by author")
library.listOfBooksInLibrary(filter: .available, sortedBy: .author)
print("\nList of books in library filter: unavailable and sorted by date")
library.listOfBooksInLibrary(filter: .unavailable, sortedBy: .date)
print("\nList of books in library filter: unavailable and sorted by person")
library.listOfBooksInLibrary(filter: .unavailable, sortedBy: .person)
print("\nList of books in library filter: unavailable and sorted by author")
library.listOfBooksInLibrary(filter: .unavailable, sortedBy: .author)
print("\nList of books in library filter: unavailable and sorted by title")
library.listOfBooksInLibrary(filter: .unavailable, sortedBy: .title)
print("\nHistory of book1")
library.historyOfBook(book1)
print("\nHistory of book2")
library.historyOfBook(book2)

try library.export(with: .title)


do {
    library.booksInLibrary = try library.removeBooksFromUserDefaults()
} catch {
    print(error)
}
do {
  library.history = try library.removeHistoryFromFile()
} catch {
    print(error)
}
