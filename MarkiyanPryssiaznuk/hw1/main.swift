//
//  main.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 3/22/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

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
print("-------------------------------------- History of book --------------------------------------")
print()
library.printHistoryOfBook(book: book1)

print()
print("-------------------------------------- ALL books --------------------------------------")
print()
library.printAll()

print("-------------------------------------- Sorted by type: --------------------------------------")
print()
for item in library.sort(sort: .byType, filter: .available) {
    let book = item.book
    let human = item.human ?? nil
    let date = item.date ?? nil
    print("book with id: was taken his author: \(book.author) | \n name: \(book.name) | \n status: \(book.status) | \n type: \(book.type) | \n it was \(book.status) at: \(String(describing: date)) | \n by: \(String(describing: human?.name)) | \n passport: \(String(describing: human?.passport))")
}
