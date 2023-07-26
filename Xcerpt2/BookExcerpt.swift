//
//  BookExcerpt.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/30/23.
//

import SwiftUI

struct BookExcerpt: View {
    @Binding var book: Book
    @State private var showScanner = false
    @State private var capturedPhoto: UIImage?
    @State private var showExtractedTextForm = false
    private let excerptColor = Color(hue: 180.0/360, saturation: 45.0/100, lightness: 95.0/100, opacity: 1.0)
    
    var body: some View {
        List {
            Section {
                BookExcerptHeader(book: $book)
            }
            Section(header: Text("\(book.excerpts.count) excerpts")) {
                ForEach(book.excerpts) { excerpt in
                    if let index = book.excerpts.firstIndex(where: { $0.id == excerpt.id}) {
                        BindingExcerptView(excerpt: $book.excerpts[index])
                            .animation(.easeInOut(duration: 1), value: book.excerpts[index].isFaceUp)
                    }
                }
            }
        }
        .toolbar {
            addButton
        }
        .onTapGesture {
            hideKeyboard()
        }
        .fullScreenCover(isPresented: $showScanner) {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    if let capturedPhoto {
                        ImageWithCroppingRectangle(setImageToNil: setImageToNil, image: capturedPhoto)
                    } else {
                        Camera(capturedPhoto: $capturedPhoto)
                    }
                    dismissText(geometry: geometry)
                }
            }
        }
    }
    
    func setImageToNil() {
        capturedPhoto = nil
    }
    
    private func dismissText(geometry: GeometryProxy) -> some View {
        ZStack {
            HStack {
                Button {
                    capturedPhoto = nil
                    showScanner = false
                } label: {
                    Label("Dismiss", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                }
                .offset(x: 10)
                Spacer()
            }
            Text("Scanner")
                .foregroundStyle(.white)
        }
        .frame(width: geometry.size.width)
        .padding(.bottom, 10)
        .background(Color.black)
    }

    private var addButton: some View {
        Button {
            showScanner = true
        } label: {
            Label("Search", systemImage: "plus")
                .labelStyle(.iconOnly)
        }
    }
}

struct BookExcerpt_Previews: PreviewProvider {
    struct Preview: View {
        // Note that this needs to be @ObservedObject and not @State, probably because Excerpt is embedded too deeply
        @ObservedObject var bookStore = BookStore()
        var body: some View {
            BookExcerpt(book: $bookStore.books[0])
        }
    }
    static var previews: some View {
       Preview()
    }
}
