//
//  main.swift
//  pllugHW
//
//  Created by Богдан Дацьків on 3/26/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

let person1 = Person(name: "Bohdan", surname: "Datskiv")
let person2 = Person(name: "John", surname: "Smith")
let person3 = Person(name: "James", surname: "Stone")

var book1 = Book(title: "The Great Gatsby", author: "Scott Fitzgerald", type: .book)
var book2 = Book(title: "To Kill a Mockingbird", author: "Harper Lee", type: .book)
var book3 = Book(title: "Harry Potter and the Sorcerer's Stone", author: "J.K. Rowling", type: .book)
var book4 = Book(title: "1984", author: "George Orwell", type: .book)
var book5 = Book(title: "Fahrenheit 451", author: "Ray Bradbury", type: .book)


let library = Library()

do{
    try library.addBook(book1)

} catch {
    print(error)
}
do{
    try library.addBook(book2)
    
} catch {
    print(error)
}
do{
    try library.addBook(book3)
    
} catch {
    print(error)
}
do{
    try library.addBook(book4)
    
} catch {
    print(error)
}
do{
    try library.addBook(book5)
    
} catch {
    print(error)
}
do{
    try library.giveBook(book5, to: person1)
    
} catch {
    print(error)
}
do{
    try library.giveBook(book1, to: person2)
    
} catch {
    print(error)
}
do{
    try library.giveBook(book4, to: person3)
    
} catch {
    print(error)
}
do{
    try library.returnBook(book5)
    
} catch {
    print(error)
}
do{
    try library.giveBook(book3, to: person1)
    
} catch {
    print(error)
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
print("\nHistory of book3")
library.historyOfBook(book3)
print("\nHistory of book4")
library.historyOfBook(book4)
print("\nHistory of book5")
library.historyOfBook(book5)
