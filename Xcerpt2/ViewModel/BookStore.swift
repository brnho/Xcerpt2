//
//  Books.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/29/23.
//

import SwiftUI

class BookStore: ObservableObject {
    @Published var books: [Book] = Book.builtins
    
    init() {
        sort(as: Order.ascending)
    }
    
    var sortOrder: Order = .ascending {
        didSet {
            sort(as: sortOrder)
        }
    }
    enum Order {
        case ascending
        case descending
    }
    
    var totalNumberOfExcerpts: Int {
        var sum = 0
        for book in books {
            sum += book.excerpts.count
        }
        return sum
    }
    
    func getRandomExcerpts(count: Int) -> [Excerpt] {
        let randomIndices = Int.getUniqueRandomNumbers(min: 0, max: totalNumberOfExcerpts-1, count: count)
        var randomExcerpts: [Excerpt] = []
        for index in randomIndices {
            if let excerpt = retrieveExcerptForIndex(of: index) {
                randomExcerpts.append(excerpt)
            }
        }
        return randomExcerpts
    }
    
    private func retrieveExcerptForIndex(of index: Int) -> Excerpt? {
        var counter = index
        for book in books {
            if counter < book.excerpts.count {
                return book.excerpts[counter]
            } else {
                counter -= book.excerpts.count
            }
        }
        return nil
    }
    
    // MARK: -Intents
    
    func sort(as order: Order) {
        switch(order) {
        case .ascending:
            books.sort { ascendingComparison(lhs: $0.title, rhs: $1.title) }
        case .descending:
            books.sort { descendingComparison(lhs: $0.title, rhs: $1.title) }
        }
    }
    
    private func ascendingComparison(lhs: String?, rhs: String?) -> Bool {
        if let lhs, let rhs {
            return lhs < rhs
        } else if lhs != nil {
            return true
        } else {
            return false
        }
    }
    
    private func descendingComparison(lhs: String?, rhs: String?) -> Bool {
        if let lhs, let rhs {
            return lhs > rhs
        } else if lhs != nil {
            return true
        } else {
            return false
        }
    }
}


