//
//  NewBookEditForm.swift
//  Xcerpt
//
//  Created by Brian Ho on 6/1/23.
//

import SwiftUI

struct NewBookEditForm: View {
    var dismiss: DismissAction
    
    @EnvironmentObject var bookStore: BookStore
    @State var book: Book
    
    private let imageWidth = 50.0
    private let imageAspectRatio = 1.5
    
    init(book: Book, dismiss: DismissAction) {
        _book = State(initialValue: Book(book: book))
        self.dismiss = dismiss
    }
    
    var body: some View {
        Form {
            Section(header: Text("Book Image")) {
                bookImageToDisplay
                colorSelector
                imageToggle
            }
            Section(header: Text("Book Info")) {
                titleSection
                VStack(alignment: .leading, spacing: 5) {
                    authorHeader
                    authorList
                }
            }
            confirmButton
        }
    }
    
    @ViewBuilder
    private var imageToggle: some View {
        if let bookUrl = book.imageLinks?.smallThumbnail, let _ = URL(string: bookUrl) {
            Toggle(isOn: $book.useCustomImage.animation()) {
                Text("Custom Image").bold()
            }
        }
    }
    
    @ViewBuilder
    private var bookImageToDisplay: some View {
        HStack() {
            Spacer()
            if book.useCustomImage {
                CustomBookImage(book: $book)
            } else {
                bookImage
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var bookImage: some View {
        if let bookUrl = book.imageLinks?.smallThumbnail, let url = URL(string: bookUrl) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: imageWidth, height: imageWidth * imageAspectRatio)
        }
    }
    
    @ViewBuilder
    private var colorSelector: some View {
        if book.useCustomImage {
            HStack {
                ColorPicker("Color 1", selection: $book.uiColor1).bold()
                    .foregroundColor(book.uiColor1)
                Divider()
                ColorPicker("Color 2", selection: $book.uiColor2).bold()
                    .foregroundColor(book.uiColor2)
            }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Title").bold()
            TextField("Add Title", text: $book.title)
                .foregroundColor(.secondary)
        }
    }
    
    private var authorHeader: some View {
        HStack {
            Text("Author(s)").bold()
            Spacer()
            Button {
                if book.authors.last != "" {
                    book.authors.append("")
                }
            } label: {
                Label("Add Author", systemImage: "plus")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    private var authorList: some View {
        ForEach(book.authors.indices, id: \.self) { index in
            HStack {
                TextField("Add Author", text: $book.authors[index])
                    .foregroundColor(.secondary)
                if book.authors.count > 1 {
                    Button {
                        book.authors.remove(at: index)
                    } label: {
                        Label("Add Author", systemImage: "minus.circle")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
    
    private var confirmButton: some View {
        Button("Confirm") {
            bookStore.books.append(book)
            dismiss()
        }
    }
}

struct NewBookEditForm_Previews: PreviewProvider {
    struct Preview: View {
        @Environment(\.dismiss) var dismiss
        var book = Book(title: "The Myth of Normal", authors: ["Gabor Maté, MD"], decodedAuthors: ["Jimmy"], imageLinks: Optional(Xcerpt2.Book.ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=beE2EAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")))
        var body: some View {
            NewBookEditForm(book: book, dismiss: dismiss)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
