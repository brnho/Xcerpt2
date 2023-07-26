//
//  BookExcerptHeader.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/30/23.
//

import SwiftUI

struct BookExcerptHeader: View {
    @Binding var book: Book
    
    private let imageWidth = 50.0
    private let imageAspectRatio = 1.5
    
    var body: some View {
        HStack {
            bookImage
            VStack(alignment: .leading) {
                HStack{
                    bookText
                    Spacer()
                    bookmarkButton
                        .overlay(book.isFavorited ? FavoritedCircle() : nil)
                }
                authorText
            }
        }
    }
    
    struct FavoritedCircle: View {
        @State var initial: Bool = true
        var body: some View {
            Circle().fill(.red)
                .opacity(initial ? 0.7 : 0)
                .scaleEffect(initial ? 1 : 2)
                .onAppear {
                    withAnimation(.spring()) {
                        initial = false
                    }
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
            .font(.title3)
            .bold()
            .lineLimit(2)
    }
    
    private var authorText: some View {
        Text(book.authors.joined(separator: ", "))
            .lineLimit(1)
            .font(.subheadline)
            .foregroundColor(.secondary)
        
    }
    
    private var bookmarkButton: some View {
        Button {
            withAnimation {
                book.isFavorited.toggle()
            }
        } label: {
            Label("Bookmark", systemImage: book.isFavorited ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(book.isFavorited ? .red : .gray)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct BookExcerptHeader_Previews: PreviewProvider {
    struct Preview: View {
        @State var book = Book.builtins[0]
        var body: some View {
            BookExcerptHeader(book: $book)
        }
    }
    static var previews: some View {
        Preview()
    }
}
