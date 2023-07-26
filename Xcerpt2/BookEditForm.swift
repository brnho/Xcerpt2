//
//  BookEditForm.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/31/23.
//

import SwiftUI

struct BookEditForm: View {
    @Binding var book: Book
    
    private let imageWidth = 50.0
    private let imageAspectRatio = 1.5
    
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
}

struct BookEditForm_Previews: PreviewProvider {
    struct Preview: View {
        @State var book = BookStore().books[0]
        var body: some View {
            BookEditForm(book: $book)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
