//
//  CustomBookImage.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/31/23.
//

import SwiftUI

struct CustomBookImage: View {
    @Binding var book: Book
    private let imageWidth = 50.0
    private let imageAspectRatio = 1.5
    private let base = RoundedRectangle(cornerRadius: 5)
    
    var body: some View {
        base
            .fill(LinearGradient.linearGradient(
                Gradient(colors: [book.uiColor1, book.uiColor2]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)))
            .frame(width: imageWidth, height: imageWidth * imageAspectRatio)
            .overlay(bookInfo)
    }
    
    var bookInfo: some View {
        VStack(spacing: 10) {
            titleText
            authorText
        }
        .padding(2)
    }
    
    var titleText: some View {
        Text(book.title)
            .font(Font.system(size: 8))
            .lineLimit(2)
    }
    
    var authorText: some View {
        Text(book.authors.joined(separator: ","))
            .font(Font.system(size: 6))
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

struct CustomBookImage_Previews: PreviewProvider {
    struct Preview: View {
        @State var book = BookStore().books[0]
        var body: some View {
            CustomBookImage(book: $book)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
