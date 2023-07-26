//
//  BookRow.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/29/23.
//

import SwiftUI

struct BookRow: View {
    @Binding var book: Book
    
    private let imageWidth = 50.0
    private let imageAspectRatio = 1.5
    
    var body: some View {
        HStack {
            bookImage
            VStack(alignment: .leading) {
                bookText
                authorText
            }
        }
    }
    
    @ViewBuilder
    private var bookImage: some View {
        if book.useCustomImage {
            CustomBookImage(book: $book)
        } else if let bookUrl = book.imageLinks?.smallThumbnail, let url = URL(string: bookUrl) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: imageWidth, height: imageWidth * imageAspectRatio)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    

    private var bookText: some View {
        Text(book.title)
            .bold()
            .lineLimit(1)
    }
    
    private var authorText: some View {
        Text(book.authors.joined(separator: ", "))
            .lineLimit(1)
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

struct BookRow_Previews: PreviewProvider {
    struct Preview: View {
        @State var book = BookStore().books[0]
        var body: some View {
            BookRow(book: $book)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
