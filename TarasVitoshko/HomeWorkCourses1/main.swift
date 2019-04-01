//
//  main.swift
//  HomeWorkCourses1
//
//  Created by Taras Vitoshko on 3/22/19.
//  Copyright © 2019 Taras Vitoshko. All rights reserved.
//

import Foundation

//
//MARK:- Enums
enum ErrorType: String, Error{
    case BooksNotRecived = "🙅‍♂️"
    case NoBooksInTheLibrary = "🤷‍♂️"
}

enum Gender: String{
    case Male = "💁🏻‍♂️"
    
    case Female = "💁🏻‍♀️"
}
enum BookType: String{
    case Book
    
    case Magazine
    
    case Newspaper
    
    case Dictionary
    
    case NoteBook
}


//MARK:- Structures

struct History {
    var book: Book
    var human: Human
    var date: Date
    var status: String
}
//MARK:- Classes

//MARK: - Book class
class Book: Comparable {
    let uuid = NSUUID().uuidString
    let author: String
    let type: BookType
    let name: String
    
    init(author: String, type: BookType, name: String) {
        self.name = name
        self.author = author
        self.type = type
    }
    static func < (lhs: Book, rhs: Book) -> Bool {
        return lhs.type.rawValue < rhs.type.rawValue
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.type.rawValue == rhs.type.rawValue
        
    }
}

// MARK:- Human Class
class Human{
    
    let name: String
    let surname: String
    let gender: Gender
    
    init(name: String, surname: String, gender: Gender) {
        self.name = name
        self.surname = surname
        self.gender = gender
    }
}

//MARK: - Library class
class Library {
    var takenBooks: [History] = []
    var recievedBooks: [History] = []
    var availableBooks: [Book] = []
    
    func addNewBook(book: Book) {
        let newBook = book
        availableBooks.append(newBook)
        print("Our new book:|\(newBook.author)|\(newBook.name)|\(newBook.type)| \nwith ID:\(newBook.uuid)| ")
        print("____________________________________________________________________________________________________________________________")
    }
    func ReciveBook(book: Book, human: Human)
    {
        let newBook = book
        availableBooks.append(newBook)
    }
    func reciveBook(book: Book, human: Human) {
        let newBook = book
        let bookRecived = History(book: book, human: human, date: Date(), status: "Recived")
        recievedBooks.append(bookRecived)
        availableBooks.append(newBook)
        }
    func takeBook(book: Book, human: Human) {
        let bookTaken = History(book: book, human: human, date: Date(),status: "Taken")
        takenBooks.append(bookTaken)
        availableBooks.removeAll { $0.uuid == book.uuid }
    }
    func sortBooks(){
        let _: [History] = takenBooks + recievedBooks
        var _: [History] = []
    }
    func printAllBooks() {
        print("All books in the library:")
        
        print("\n Taken books from the library:")
        print("_______________________________________________________________________________________________________")
        if(takenBooks.count == 0){
            print(" There are no books taken")
        }else{
        for book in takenBooks {
            print("|\(book.book.author)|\(book.book.name)|\(book.book.type.rawValue)|with ID:\(book.book.uuid) \nBy \(book.human.name)|\(book.human.surname)|\(book.human.gender.rawValue) in \(book.date)| \nStatus:\(book.status)|")
            print("_____________________________________________________________________________________")
        
            }
        }
        
        print("\n Recived books to the library:")
        print("_______________________________________________________________________________________________________")
        if(recievedBooks.count == 0)
        {
            print(" There are no books recived")
        }else{
        for book in recievedBooks {
            print("|\(book.book.author)|\(book.book.name)|\(book.book.type.rawValue)|with ID: \(book.book.uuid) \n By \(book.human.name)| \(book.human.surname)|\(book.human.gender.rawValue) in \(book.date) \n|Status: \(book.status)|")
               print("_______________________________________________________________________________________________________")
            
        }
        }
        print("\n Available books in the library:")
        print("_______________________________________________________________________________________________________")
        for book in availableBooks {
            print("| \(book.author) | \(book.name) | \(book.type.rawValue)| with ID: \(book.uuid) |")
            print("_______________________________________________________________________________________________________")
        }
    }
    
    
}

//MARK: - Initialization

let book1 = Book(author: "Oobah Butler", type: .Newspaper, name: "Georgio Peviani")
let book2 = Book(author: "Taras Vitoshko", type: .NoteBook, name: "My personal notebook")
let book3 = Book(author: "Oscar Uald", type: .Book, name: "The Picture of Dorian Gray")
let book4 = Book(author: "Friedrich Nietzsche", type: .Dictionary, name: "Beyong good and evil")
let book5 = Book(author: "Stiven King", type: .Book, name: "Dark Tower")



let human1 = Human(name: "Taras", surname: "Vitoshko", gender: .Male)
let human2 = Human(name: "Zoriana", surname: "Barna", gender: .Female)

let library = Library()
// MARK:- Output

library.addNewBook(book: book1)
library.addNewBook(book: book2)
library.addNewBook(book: book3)
library.addNewBook(book: book4)
print()
library.takeBook(book: book3, human: human1)
library.takeBook(book: book2, human: human2)
print()
library.reciveBook(book: book2, human: human2)
print()
library.takeBook(book: book4, human: human1)
print()
library.printAllBooks()

