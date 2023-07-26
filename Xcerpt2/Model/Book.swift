//
//  Book.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/27/23.
//

import Foundation

struct GoogleBooks: Codable {
    let items: [GoogleBookWrapper]
    
    struct GoogleBookWrapper: Codable, Identifiable {
        var id = UUID()
        var volumeInfo: Book
        enum CodingKeys: CodingKey {
            case volumeInfo
        }
    }
    
    struct GoogleBook: Codable {
        var title: String = ""
        var authors: [String]?
        var imageLinks: ImageLinks?
        struct ImageLinks: Codable, Hashable {
            let smallThumbnail: String
        }
    }
}


struct Book: Codable, Identifiable, Hashable {
    var id = UUID()
    var title: String = ""
    var authors: [String] = [""]
    var decodedAuthors: [String]?
    var imageLinks: ImageLinks?
    struct ImageLinks: Codable, Hashable {
        let smallThumbnail: String
    }
    var excerpts: [Excerpt] = []
    var isFavorited = false
    var useCustomImage = false
    var color1: RGBA = RGBA(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255, alpha: 1.0)
    var color2: RGBA = RGBA(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, alpha: 1.0)
    
    enum CodingKeys: String, CodingKey {
        case decodedAuthors = "authors"
        case title, imageLinks
    }
}

extension Book {
    // this initializer is for when we're adding a book and we need to set authors to decodedAuthors for a google book
    init(book: Book) {
        self = book
        if let authors = self.decodedAuthors {
            self.authors = authors
        }
    }
    
    static var builtins: [Book] = [
        Book(title: "What Do You Care What Other People Think?",
             authors: ["Richard P Feynman"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=El2NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "The Lords of Easy Money",
             authors: ["Christopher Leonard"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=AdhUEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "Range",
             authors: ["David Epstein"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=ma1sDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "My Life as a Quant",
             authors: ["Emanuel Derman"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=JUy3EAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "Steve Jobs",
             authors: ["Walter Isaacson"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=_IFhBAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "The Happiness Hypothesis",
             authors: ["Jonathan Haidt"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=cg-ptAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "Makers and Takers",
             authors: ["Rana Foroohar"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=faouDAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
             excerpts: Excerpt.builtins),
        Book(title: "The Myth of Normal",
             authors: ["Gabor Maté, MD"],
             imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=beE2EAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
             excerpts: Excerpt.builtins)
        ]
}


